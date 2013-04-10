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
    self.delegate = self;
    self.allowsMultipleSelection = NO;
    [self loadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    NSDictionary<FBGraphUser> *user = friendPicker.selection[0];
    
    // This link open default facebook app but i got auth windows for app
    //NSString *str = [NSString stringWithFormat:@"fb://profile/%@", user.id];
    NSString *str = [NSString stringWithFormat:@"http://www.facebook.com/%@", user.id];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:url];
    NSLog(@"Current friend selections: %@", friendPicker.selection);
}

@end
