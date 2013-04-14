//
//  FriendCell.m
//  42cc_test
//
//  Created by oles on 4/13/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

@synthesize tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)actionTogglePriority:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:self.friendID])
    {
        // set to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.friendID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // exchange objects
        [appDelegate.userFriendsLow addObjectsFromArray:[[NSArray alloc] initWithObjects:appDelegate.userFriendsHi[self.friendIndex], nil]];
        [appDelegate.userFriendsHi removeObjectAtIndex:self.friendIndex];
        
    } else {
        // set to NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.friendID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // exchange objects
        [appDelegate.userFriendsHi addObjectsFromArray:[[NSArray alloc] initWithObjects:appDelegate.userFriendsLow[self.friendIndex], nil]];
        [appDelegate.userFriendsLow removeObjectAtIndex:self.friendIndex];
        
    }
    [self.tableView reloadData];
}
@end
