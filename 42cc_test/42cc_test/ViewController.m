//
//  ViewController.m
//  42cc_test
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize managedObjectContext, fetchedResultsController, people, loggedInUser;


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


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    // fill info about person
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    people = (People *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self updateOutlets];
    [self facebookLogin];
}


#pragma mark -
#pragma mark Facebook support

- (void)facebookLogout:(id)sender {
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [self facebookLogin];
    NSLog(@"facebook logout!");
}

- (void)facebookLogin {
    
    FBRequestHandler handler = ^ (FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        
        if (([FBSession activeSession].state == FBSessionStateClosed) ||
            ([FBSession activeSession].state == FBSessionStateClosedLoginFailed))
            return;
        
        if (!error) {
            
            people.name = user.first_name;
            people.surname = user.last_name;
            people.contacts = [user objectForKey:@"email"];
            people.bio = user[@"bio"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            [formatter setTimeZone:gmt];
            NSDate *date = [formatter dateFromString:user.birthday];
            people.birth = date;
            
            NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=128&height=128",user.id];
            people.photo = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (people.photo == nil)
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
        }
        [self performSelectorOnMainThread:@selector(updateOutlets) withObject:nil waitUntilDone:NO];
        
        [self.activityIndicator stopAnimating];
        
    };
    
    if (![[FBSession activeSession] isOpen])
    {
        NSArray *permissions =
        [NSArray arrayWithObjects:@"email", @"user_photos", @"user_birthday", @"user_about_me", nil];
        [self.activityIndicator startAnimating];
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
                                              }
                                          } else {
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Facebook login error" message:@"Try one more time?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                                              [alert show];
                                              NSLog(@"error: %@", error);
                                          }
                                      }];
    } else {
        [[[FBRequest alloc] initWithSession:[FBSession activeSession] graphPath:@"me"] startWithCompletionHandler:handler];
    }
    
    
    
    [self.activityIndicator stopAnimating];
}


- (void)updateOutlets {
    // name
    NSMutableString *fullName = [[NSMutableString alloc] initWithString:people.name];
    [fullName appendString:@" "];
    [fullName appendString:people.surname];
    self.labelName.text = fullName;
    // birth
    self.labelBirth.text = [NSDateFormatter localizedStringFromDate:people.birth
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    self.labelContacts.text = people.contacts;
    self.textViewBio.text = people.bio;
    self.imagePhoto.image = [UIImage imageWithData:people.photo];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditData"]) {
        UINavigationController *navController = [segue destinationViewController];
        EditViewController *editViewController = navController.childViewControllers[0];
        
        // set properties
        editViewController.peopleName = people.name;
        editViewController.peopleLastName = people.surname;
        editViewController.peopleEmail = people.contacts;
        editViewController.peopleBio = people.bio;
        editViewController.peopleBirth = people.birth;
        
        editViewController.delegate = self;
    }
}

#pragma mark - AddItemControllerDelegate

- (void)editItemControllerDidSave:(EditViewController *)controller
                             name:(NSString *)name
                         lastName:(NSString *)lastName
                         birthday:(NSDate *)birthday
                         contacts:(NSString *)contacts
                              bio:(NSString *)bio;

{
    if ([name length] || [lastName length]) {
        people.name = name;
        people.surname = lastName;
        people.birth = birthday;
        people.contacts = contacts;
        people.bio = bio;
        
        [self.managedObjectContext save:nil];
        [self.fetchedResultsController performFetch:nil];
        [self updateOutlets];
    }
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // return YES for supported orientations
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#endif

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"People" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
    }
    
    return fetchedResultsController;
}


@end
