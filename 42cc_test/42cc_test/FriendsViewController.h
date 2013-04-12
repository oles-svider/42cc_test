//
//  FriendsViewController.h
//  42cc_test
//
//  Created by oles on 4/9/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


//@interface FriendsViewController : FBFriendPickerViewController <FBFriendPickerDelegate>

@interface FriendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) NSMutableArray *userFriends;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
