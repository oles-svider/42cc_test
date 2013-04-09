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


@interface ViewController : UIViewController <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, EditItemControllerDelegate>  {
@private
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

-(void)updateOutlets;

- (IBAction)facebookLogout:(id)sender;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelBirth;
@property (strong, nonatomic) IBOutlet UILabel *labelContacts;
@property (strong, nonatomic) IBOutlet UITextView *textViewBio;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogout;
@property (strong, nonatomic) IBOutlet UIButton *buttonEdit;

@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) People *people;
@property (nonatomic, strong) NSString *profileID;


@end
