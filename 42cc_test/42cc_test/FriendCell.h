//
//  FriendCell.h
//  42cc_test
//
//  Created by oles on 4/13/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface FriendCell : UITableViewCell

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) Friend *friendInfo;

@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UIButton *buttonPriority;

- (IBAction)actionTogglePriority:(id)sender;

@end
