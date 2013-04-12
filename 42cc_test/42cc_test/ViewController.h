//
//  EditViewController.h
//  42cc_test
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"
#import "People.h"
#import "EditViewController.h"
#import "FriendsViewController.h"


@interface ViewController : UIViewController <EditItemControllerDelegate>  {
@private
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

-(void)updateOutlets;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelBirth;
@property (strong, nonatomic) IBOutlet UILabel *labelContacts;
@property (strong, nonatomic) IBOutlet UITextView *textViewBio;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogout;
@property (strong, nonatomic) IBOutlet UIButton *buttonEdit;

- (IBAction)actionLogout:(id)sender;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) AppDelegate *appDelegate;


@end
