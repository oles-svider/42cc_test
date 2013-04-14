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
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableView

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
 return @"section";
 }
 */

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
    
    // configure cell
    NSMutableArray *friendSource = nil;
    if (indexPath.section == 0) {
        friendSource = self.appDelegate.userFriendsHi;
        cell.boolHiPriority = true;
    } else {
        friendSource = self.appDelegate.userFriendsLow;
        cell.boolHiPriority = false;
    }
    
    cell.imagePhoto.image = [friendSource[indexPath.row] objectForKey:@"picture"];
    cell.labelName.text = [friendSource[indexPath.row] objectForKey:@"name"];
    cell.friendID = [friendSource[indexPath.row] objectForKey:@"id"];
    cell.tableView = self.tableView;
    cell.friendIndex = indexPath.row;
    
    if (indexPath.section == 0)
        [cell.buttonPriority setImage:[UIImage imageNamed:@"down_24"] forState:UIControlStateNormal];
    else
        [cell.buttonPriority setImage:[UIImage imageNamed:@"up_24"] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This link open default facebook app but i got auth windows for app
    //NSString *str = [NSString stringWithFormat:@"fb://profile/%@", user.id];
    
    NSString *friendID = nil;
    
    if (indexPath.section == 0)
        friendID = [self.appDelegate.userFriendsHi[indexPath.row] objectForKey:@"id"];
    else friendID = [self.appDelegate.userFriendsLow[indexPath.row] objectForKey:@"id"];
    
    NSString *str = [NSString stringWithFormat:@"http://www.facebook.com/%@", friendID];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Current friend selections: %@", friendID);
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return self.appDelegate.userFriendsHi.count;
    else return self.appDelegate.userFriendsLow.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"High Priority";
            break;
        case 1:
            sectionName = @"Low Priority";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}


@end
