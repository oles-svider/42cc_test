//
//  ApplicationTests.m
//  ApplicationTests
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "ApplicationTests.h"

@implementation ApplicationTests

@synthesize viewController, editViewController, friendsViewController;
@synthesize appDelegate;


#pragma -
#pragma Setup and teardown


- (void)setUp {
    // Set-up code here.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.viewController view];
    
    self.editViewController = [storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    [self.editViewController view];
    self.editViewController.delegate = self.viewController;
    
    self.friendsViewController = [storyboard instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    [self.friendsViewController view];
    
}

- (void)tearDown {
    // Tear-down code here.
    self.viewController = nil;
    self.editViewController = nil;
    self.friendsViewController = nil;
    
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

- (void)testThatDelegateFetchResultControllerIsntNil {
    STAssertNotNil(self.appDelegate.fetchedResultsController, @"appDelegate.fetchedResultsController wasn't set properly");
}


#pragma -
#pragma View Controls inits check

- (void) testViewBinding {
    //[self.viewController view];
    STAssertNotNil(viewController.view, @"viewController wasn't set properly");
    STAssertNotNil(viewController.labelName, @"viewController.labelName is nil");
    STAssertNotNil(viewController.labelBirth, @"viewController.labelBirthday is nil");
    STAssertNotNil(viewController.labelContacts, @"viewController.labelContacts is nil");
    STAssertNotNil(viewController.textViewBio, @"viewController.textViewBio is nil");
    STAssertNotNil(viewController.textViewBio, @"viewController.textViewBio is nil");
    STAssertNotNil(viewController.imagePhoto, @"viewController.imagePhoto is nil");
}

- (void) testUIButtonActionBinding {
    // Nothing to check at least now
}

- (void) testEditViewController {
    STAssertNotNil(self.editViewController.view, @"editViewController wasn't set properly");
    STAssertNotNil(self.editViewController.labelBirth, @"editViewController.labelBirth is nil");
    STAssertNotNil(self.editViewController.textFieldName, @"editViewController.textFieldName is nil");
    STAssertNotNil(self.editViewController.textFieldLastName, @"editViewController.textFieldLastName is nil");
    STAssertNotNil(self.editViewController.textViewBio, @"editViewController.textViewBio is nil");
    STAssertNotNil(self.editViewController.textFieldEmail, @"editViewController.textFieldEmail is nil");
}

- (void) testFriendsViewController {
    STAssertNotNil(self.friendsViewController.view, @"friendsController wasn't set properly");
    STAssertNotNil(self.friendsViewController.tableView, @"friendsController.tableView is nil");
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
#pragma CoreData for ViewController inits check

- (void)testThatFetchedResultsControllerIsntNil {
    STAssertNotNil(self.viewController.fetchedResultsController, @"viewController.fetchedResultsController wasn't set properly");
}

- (void)testThatManagedObjectContextIsntNil {
    STAssertNotNil(self.viewController.managedObjectContext, @"viewController.managedObjectContext wasn't set properly");
}

#pragma -
#pragma Controls properties checks

- (void)testThatPeopleNameIsntNil {
    STAssertNotNil(self.viewController.labelName.text, @"labelName.text is void");
}


#pragma -
#pragma EditViewController checks


- (void)testIsEmailValidInline {
    STAssertTrue([self.editViewController validateEmailWithString:@"1@1.com"], @"Inline email validation failed - valid email shown as invalid");
    STAssertTrue(![self.editViewController validateEmailWithString:@"test.com"], @"Inline email validation failed - invalid email  shown as valid");
}


- (void)testFieldsValidationGui {
    self.editViewController.textFieldName.text = @"";
    self.editViewController.textFieldLastName.text = @"LastName";
    self.editViewController.textFieldEmail.text = @"not_a_valid_email";
    self.editViewController.textViewBio.text = @"Bio";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:gmt];
    self.editViewController.peopleBirth = [formatter dateFromString:@"05/29/1979"];
    self.editViewController.delegate = self.viewController;
    
    [self.viewController.navigationController popToViewController:self.editViewController animated:YES];
    [self.editViewController saveAction:nil];
    
    // check is data stored in database
    NSError *error = nil;
	if (![self.appDelegate.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    People *people = (People *)[self.appDelegate.fetchedResultsController objectAtIndexPath:indexPath];
    // check for name length > 0
    STAssertTrue(([people.name length] > 0), @"Name field length is 0");
    // check for valid email
    STAssertTrue(![people.contacts isEqualToString:@"not_a_valid_email"], @"Invalid Email stored in database");
    
}


- (void)testIsAddPeopleWorks {
    
    self.editViewController.textFieldName.text = @"TestName";
    self.editViewController.textFieldLastName.text = @"LastName";
    self.editViewController.textFieldEmail.text = @"email@email.com";
    self.editViewController.textViewBio.text = @"Bio";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:gmt];
    self.editViewController.peopleBirth = [formatter dateFromString:@"05/29/1979"];
    self.editViewController.delegate = self.viewController;
    
    [self.viewController.navigationController popToViewController:self.editViewController animated:YES];
    
    [self.editViewController saveAction:nil];
    
    // check is data stored in database
    NSError *error = nil;
	if (![self.appDelegate.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    People *people = (People *)[self.appDelegate.fetchedResultsController objectAtIndexPath:indexPath];
    
    STAssertTrue([people.name isEqualToString:@"TestName"], @"Name field didn't save correctly hile editing people properties");
    STAssertTrue([people.surname isEqualToString:@"LastName"], @"SurName field didn't save correctly hile editing people properties");
    STAssertTrue([people.contacts isEqualToString:@"email@email.com"], @"Email field didn't save correctly hile editing people properties");
    STAssertTrue([people.bio isEqualToString:@"Bio"], @"Bio field didn't save correctly hile editing people properties");
    STAssertTrue([people.birth isEqualToDate:[formatter dateFromString:@"05/29/1979"]], @"Birthday field didn't save correctly hile editing people properties");
}



@end
