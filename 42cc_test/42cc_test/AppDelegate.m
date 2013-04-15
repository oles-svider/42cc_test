//
//  AppDelegate.m
//  42cc_test
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize managedObjectModel, persistentStoreCoordinator, managedObjectContext, fetchedResultsController, people, fetchedResultsControllerForFriends;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    error = nil;
	if (![self.fetchedResultsControllerForFriends performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    self.boolFriendsLoaded = false;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    people = (People *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self facebookLogin];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Facebook logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    
    [FBSession.activeSession handleDidBecomeActive];
}


// Facebook logic
// The native facebook application transitions back to an authenticating application when the user
// chooses to either log in, or cancel. The url passed to this method contains the token in the
// case of a successful login. By passing the url to the handleOpenURL method of a session object
// the session object can parse the URL, and capture the token for use by the rest of the authenticating
// application; the return value of handleOpenURL indicates whether or not the URL was handled by the
// session object, and does not reflect whether or not the login was successful; the session object's
// state, as well as its arguments passed to the state completion handler indicate whether the login
// was successful; note that if the session is nil or closed when handleOpenURL is called, the expression
// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

// Facebook logic
// Whether it is in applicationWillTerminate, in applicationDidEnterBackground, or in some other part
// of your application, it is important that you close an active session when it is no longer useful
// to your application; if a session is not properly closed, a retain cycle may occur between the block
// and an object that holds a reference to the session object; close releases the handler, breaking any
// inadvertant retain cycles
- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [FBSession.activeSession close];
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // cancel - exit application
            abort();
            break;
        case 1:
            // ok - retry login
            [self facebookLogin];
            break;
        default:
            break;
    }
    NSLog(@"Alert View dismissed with button at index %d",buttonIndex);
}


- (void)facebookLogout {
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [self facebookLogin];
    NSLog(@"facebook logout!");
}


- (void)clearFriendsList {
    NSFetchRequest * allFriends = [[NSFetchRequest alloc] init];
    [allFriends setEntity:[NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext]];
    [allFriends setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * friends = [self.managedObjectContext executeFetchRequest:allFriends error:&error];
    
    //error handling goes here
    for (NSManagedObject * friend in friends) {
        [self.managedObjectContext deleteObject:friend];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

- (void)facebookLogin {
    
    FBRequestHandler friendsHandler = ^ (FBRequestConnection *connection, NSDictionary *result, NSError *error) {
        
        NSDictionary* friends = [result objectForKey:@"data"];
        NSLog(@"Found: %i friends", friends.count);
        
        if (friends.count > 0)
            [self clearFriendsList];
        
        for (NSDictionary<FBGraphUser>* friend in friends) {
            NSLog(@"I have a friend named %@ with info %@", friend.name, friend);
            
            Friend *friendObject = (Friend *)[NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
            
            // picture
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=64&height=64", friend.id];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            friendObject.friend_id = friend.id;
            friendObject.photo = data;
            friendObject.name = friend.name;
            friendObject.priority = [NSNumber numberWithInt:0];
        }
        
        NSError *merror;
        if (![self.managedObjectContext save:&merror]) {
            NSLog(@"Unresolved error while saving  - %@, %@", merror, [merror userInfo]);
            abort();
        }
        
        self.boolFriendsLoaded = true;
        [[self.window.rootViewController presentedViewController] performSegueWithIdentifier: @"CloseSplash" sender: self];
    };
    
    
    FBRequestHandler handler = ^ (FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        
        if (!error) {
            
            self.people.name = user.first_name;
            self.people.surname = user.last_name;
            self.people.contacts = [user objectForKey:@"email"];
            self.people.bio = user[@"bio"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [formatter setTimeZone:gmt];
            NSDate *date = [formatter dateFromString:user.birthday];
            self.people.birth = date;
            
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=128&height=128",user.id];
            self.people.photo = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (self.people.photo == nil)
                NSLog(@"Can't get facebook picture using graph url - %@", url);
            
            NSError *merror;
            if (![self.managedObjectContext save:&merror]) {
                NSLog(@"Unresolved error at startWithCompletionHandler - %@, %@", merror, [merror userInfo]);
                abort();
            }
            
            NSLog(@"UserName: %@", user.username);
            NSLog(@"Name: %@", user.first_name);
            NSLog(@"Last Name: %@", user.last_name);
            NSLog(@"Birthday: %@", user.birthday);
            NSLog(@"Bio: %@", user[@"bio"]);
            NSLog(@"Email: %@", user[@"email"]);
        } else NSLog(@"Error in FBRequestHandler handler - %@, %@", error, [error userInfo]);
        
    };
    
    self.boolFriendsLoaded = true;
    if (![[FBSession activeSession] isOpen])
    {
        NSArray *permissions =
        [NSArray arrayWithObjects:@"email", @"user_photos", @"user_birthday", @"user_about_me", nil];
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                          /* handle success + failure in block */
                                          if (!error) {
                                              if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
                                              {
                                                  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
                                                  [[NSUserDefaults standardUserDefaults] synchronize];
                                                  
                                                  [[[FBRequest alloc] initWithSession:session graphPath:@"me"] startWithCompletionHandler:handler];
                                                  
                                                  self.boolFriendsLoaded = false;
                                                  [self.window.rootViewController performSegueWithIdentifier: @"CreateSplash" sender: self];
                                                  FBRequest* friendsRequest = [FBRequest requestForMyFriends];
                                                  [friendsRequest startWithCompletionHandler:friendsHandler];
                                              }
                                              
                                          } else {
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Facebook login error" message:@"Try one more time?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                                              [alert show];
                                              NSLog(@"error: %@", error);
                                          }
                                      }];
        
    }
    
    while (!self.boolFriendsLoaded)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}



#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [NSManagedObjectContext new];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Data.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
    
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"People" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
    }
    
    return fetchedResultsController;
}


- (NSFetchedResultsController *)fetchedResultsControllerForFriends {
    // Set up the fetched results controller if needed.
    if (fetchedResultsControllerForFriends == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptorPriority = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:NO];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorPriority, sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsControllerForFriends = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"priority" cacheName:@"Root"];
        aFetchedResultsControllerForFriends.delegate = self;
        self.fetchedResultsControllerForFriends = aFetchedResultsControllerForFriends;
    }
    
    return fetchedResultsControllerForFriends;
}

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
