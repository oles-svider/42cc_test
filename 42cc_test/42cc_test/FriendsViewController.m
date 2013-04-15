//
//  FriendsViewController.m
//  42cc_test
//
//  Created by oles on 4/9/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

@synthesize tableView, appDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSError *error = nil;
	if (![appDelegate.fetchedResultsControllerForFriends performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    //UITableViewCell *cell = nil;
    FriendCell *cell = nil;
    
    cell = (FriendCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[FriendCell alloc] init];
        
    }
    
    Friend *friend = (Friend *)[appDelegate.fetchedResultsControllerForFriends objectAtIndexPath:indexPath];
    cell.imagePhoto.image = [UIImage imageWithData:friend.photo];
    cell.labelName.text = friend.name;
    cell.friendInfo = friend;
    cell.tableView = self.tableView;
    if ([friend.priority isEqualToNumber:[NSNumber numberWithInt:1]])
        [cell.buttonPriority setImage:[UIImage imageNamed:@"down_24"] forState:UIControlStateNormal];
    else
        [cell.buttonPriority setImage:[UIImage imageNamed:@"up_24"] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This link open default facebook app but i got auth windows for app
    //NSString *str = [NSString stringWithFormat:@"fb://profile/%@", user.id];
    
    NSString *friendID = nil;
    
    Friend *friend = (Friend *)[appDelegate.fetchedResultsControllerForFriends objectAtIndexPath:indexPath];
    friendID = friend.friend_id;
    
    NSString *str = [NSString stringWithFormat:@"http://www.facebook.com/%@", friendID];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Current friend selections: %@", friendID);
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[appDelegate.fetchedResultsControllerForFriends sections] objectAtIndex:section];
    int numberOfRows = [sectionInfo numberOfObjects];
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[appDelegate.fetchedResultsControllerForFriends sections] count];
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[appDelegate.fetchedResultsControllerForFriends sections] objectAtIndex:section];
    NSString *name;
    if ([[sectionInfo name] isEqual:@"1"])
        name = @"Hi priority";
    else name = @"Low priority";
    return name;
}


@end
