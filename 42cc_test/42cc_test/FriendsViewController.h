//
//  FriendsViewController.h
//  42cc_test
//
//  Created by oles on 4/9/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "FriendCell.h"

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end
