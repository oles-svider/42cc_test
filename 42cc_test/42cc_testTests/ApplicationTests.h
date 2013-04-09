//
//  ApplicationTests.h
//  ApplicationTests
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "AppDelegate.h"
#import "ViewController.h"


@interface ApplicationTests : SenTestCase

@property(nonatomic, weak) AppDelegate *appDelegate;
@property(nonatomic, weak) ViewController *viewController;
@property(nonatomic, weak) EditViewController *editViewController;


@end
