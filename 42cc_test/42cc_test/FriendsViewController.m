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
    UITableViewCell *cell = nil;
    
    cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // configure cell
    cell.textLabel.text = [self.appDelegate.userFriends[indexPath.row] objectForKey:@"name"];
    cell.imageView.image = [self.appDelegate.userFriends[indexPath.row] objectForKey:@"picture"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This link open default facebook app but i got auth windows for app
    //NSString *str = [NSString stringWithFormat:@"fb://profile/%@", user.id];
    NSString *str = [NSString stringWithFormat:@"http://www.facebook.com/%@", [self.appDelegate.userFriends[indexPath.row] objectForKey:@"id"]];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Current friend selections: %@", self.appDelegate.userFriends[indexPath.row]);
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appDelegate.userFriends.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
