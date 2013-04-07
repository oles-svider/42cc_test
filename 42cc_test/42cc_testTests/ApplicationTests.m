//
//  ApplicationTests.m
//  ApplicationTests
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "ApplicationTests.h"

@implementation ApplicationTests

@synthesize viewController;
@synthesize appDelegate;


#pragma -
#pragma Setup and teardown


- (void)setUp {
    // Set-up code here.
    UIApplication *applicatin = [UIApplication sharedApplication];
    appDelegate = [applicatin delegate];
    UIWindow *window = [appDelegate window];
    UIViewController * c = (ViewController *)[window rootViewController];
    if (c != nil) {
        self.viewController = [[c childViewControllers] objectAtIndex:0];
    }
}

- (void)tearDown {
    // Tear-down code here.
    self.viewController = nil;
    
    [super tearDown];
}


#pragma -
#pragma appDelegate check

- (void)testThatDelegateManagedObjectModelIsntNil {
    STAssertNotNil(self.appDelegate.managedObjectModel, @"appDelegate.managedObjectModel wasn't set properly");
}

- (void)testThatDelegateManagedObjectContextIsntNil {
    STAssertNotNil(self.appDelegate.managedObjectContext, @"appDelegate.managedObjectContext wasn't set properly");
}

- (void)testThatDelegatePersistentStorageIsntNil {
    STAssertNotNil(self.appDelegate.persistentStoreCoordinator, @"appDelegate.persistentStoreCoordinator wasn't set properly");
}


#pragma -
#pragma View Controls inits check

- (void) testViewBinding {
    [self.viewController view];
    STAssertNotNil(viewController.view, @"viewController wasn't set properly");
    STAssertNotNil(viewController.labelName, @"labelName is nil");
    STAssertNotNil(viewController.labelBirth, @"labelBirthday is nil");
    STAssertNotNil(viewController.labelContacts, @"labelContacts is nil");
    STAssertNotNil(viewController.textViewBio, @"textViewBio is nil");
    STAssertNotNil(viewController.textViewBio, @"textViewBio is nil");
    STAssertNotNil(viewController.imagePhoto, @"imagePhoto is nil");
}

- (void) testUIButtonActionBinding {
    [self.viewController view];
    // Nothing to check at least now
}

- (void) testEditViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    EditViewController *editViewController = [storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    [editViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    STAssertNotNil(editViewController.view, @"viewController wasn't set properly");
    STAssertNotNil(editViewController.labelBirth, @"labelBirth is nil");
    STAssertNotNil(editViewController.textFieldName, @"textFieldName is nil");
    STAssertNotNil(editViewController.textFieldLastName, @"textFieldLastName is nil");
    STAssertNotNil(editViewController.textViewBio, @"textViewBio is nil");
    STAssertNotNil(editViewController.textFieldEmail, @"textFieldEmail is nil");
}


#pragma -
#pragma Facebook tests

- (void) testFacebookSession {
    STAssertNotNil([FBSession activeSession], @"FBSession activeSession is nil");
}

- (void) testFacebookSessionIsOpen {
    STAssertTrue([[FBSession activeSession] isOpen], @"FBSession activeSession isn't open");
}



#pragma -
#pragma CoreData inits check

- (void)testThatfetchedResultsControllerIsntNil {
    STAssertNotNil(self.viewController.fetchedResultsController, @"fetchedResultsController wasn't set properly");
}

- (void)testThatManagedObjectContextIsntNil {
    STAssertNotNil(self.viewController.managedObjectContext, @"managedObjectContext wasn't set properly");
}

#pragma -
#pragma Controls properties checks

- (void)testThatPeopleNameIsntNil {
    STAssertNotNil(self.viewController.labelName.text, @"labelName.text is void");
}



@end
