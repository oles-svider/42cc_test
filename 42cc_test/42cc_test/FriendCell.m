//
//  FriendCell.m
//  42cc_test
//
//  Created by oles on 4/13/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

@synthesize tableView, friendInfo;

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
    
    if ([friendInfo.priority isEqualToNumber:[NSNumber numberWithInt:0]])
        friendInfo.priority = [NSNumber numberWithInt:1];
    else
        friendInfo.priority = [NSNumber numberWithInt:0];
    
    NSError *saveError = nil;
    [appDelegate.managedObjectContext save:&saveError];
    
    NSError *error = nil;
	if (![appDelegate.fetchedResultsControllerForFriends performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [self.tableView reloadData];
}

@end
