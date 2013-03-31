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

- (void)setUp
{
    // Set-up code here.
    UIApplication *applicatin = [UIApplication sharedApplication];
    AppDelegate *appDelegate = [applicatin delegate];
    UIWindow *window = [appDelegate window];
    UIViewController * c = (ViewController *)[window rootViewController];
    self.viewController = [[c childViewControllers] objectAtIndex:0];
}

- (void)tearDown
{
    // Tear-down code here.
    self.viewController = nil;
    
    [super tearDown];
}

#pragma -
#pragma View Controls inits check

- (void)testThatViewControllerIsntNil
{
    STAssertNotNil(self.viewController, @"viewController wasn't set properly");
}

#pragma -
#pragma CoreData inits check

- (void)testThatfetchedResultsControllerIsntNil
{
    STAssertNotNil(self.viewController.fetchedResultsController, @"fetchedResultsController wasn't set properly");
}

- (void)testThatManagedObjectContextIsntNil
{
    STAssertNotNil(self.viewController.managedObjectContext, @"managedObjectContext wasn't set properly");
}

#pragma -
#pragma Controls properties checks

- (void)testThatPeopleNameIsntNil
{
    STAssertNotNil(self.viewController.labelName.text, @"labelName.text is void");
}


@end
