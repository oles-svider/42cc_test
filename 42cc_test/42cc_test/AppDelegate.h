//
//  AppDelegate.h
//  42cc_test
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>

#import "People.h"
#import "Friend.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSFetchedResultsController *fetchedResultsController;
    NSFetchedResultsController *fetchedResultsControllerForFriends;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsControllerForFriends;

- (NSString *)applicationDocumentsDirectory;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (nonatomic, strong) People *people;

@property __block BOOL *boolFriendsLoaded;


- (void)facebookLogout;
- (void)facebookLogin;
- (void)clearFriendsList;


@end
