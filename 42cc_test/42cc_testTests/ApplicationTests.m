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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.editViewController = [storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    
    [self.editViewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    self.editViewController.delegate = self.viewController;

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
    
    STAssertNotNil(self.editViewController.view, @"viewController wasn't set properly");
    STAssertNotNil(self.editViewController.labelBirth, @"labelBirth is nil");
    STAssertNotNil(self.editViewController.textFieldName, @"textFieldName is nil");
    STAssertNotNil(self.editViewController.textFieldLastName, @"textFieldLastName is nil");
    STAssertNotNil(self.editViewController.textViewBio, @"textViewBio is nil");
    STAssertNotNil(self.editViewController.textFieldEmail, @"textFieldEmail is nil");
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
    
    // check for name length > 0
    STAssertTrue(!([self.viewController.people.name length] > 0), @"Name field length is 0");
    
    // check for valid email
    STAssertTrue(![self.viewController.people.contacts isEqualToString:@"not_a_valid_email"], @"Invalid Email stored in database");
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
    STAssertTrue([self.viewController.people.name isEqualToString:@"TestName"], @"Name field didn't save correctly hile editing people properties");
    STAssertTrue([self.viewController.people.surname isEqualToString:@"LastName"], @"SurName field didn't save correctly hile editing people properties");
    STAssertTrue([self.viewController.people.contacts isEqualToString:@"email@email.com"], @"Email field didn't save correctly hile editing people properties");
    STAssertTrue([self.viewController.people.bio isEqualToString:@"Bio"], @"Bio field didn't save correctly hile editing people properties");
    STAssertTrue([self.viewController.people.birth isEqualToDate:[formatter dateFromString:@"05/29/1979"]], @"Birthday field didn't save correctly hile editing people properties");
}



@end
