//
//  ViewController.m
//  42cc_test
//
//  Created by oles on 3/26/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize managedObjectContext, fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    self.fetchedResultsController = self.appDelegate.fetchedResultsController;
    
    [self updateOutlets];
}


- (void)updateOutlets {
    // name
    NSMutableString *fullName = [[NSMutableString alloc] initWithString:self.appDelegate.people.name];
    [fullName appendString:@" "];
    [fullName appendString:self.appDelegate.people.surname];
    self.labelName.text = fullName;
    // birth
    self.labelBirth.text = [NSDateFormatter localizedStringFromDate:self.appDelegate.people.birth
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    self.labelContacts.text = self.appDelegate.people.contacts;
    self.textViewBio.text = self.appDelegate.people.bio;
    self.imagePhoto.image = [UIImage imageWithData:self.appDelegate.people.photo];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"EditData"]) {
        UINavigationController *navController = [segue destinationViewController];
        EditViewController *editViewController = navController.childViewControllers[0];
        
        // set properties
        editViewController.peopleName = self.appDelegate.people.name;
        editViewController.peopleLastName = self.appDelegate.people.surname;
        editViewController.peopleEmail = self.appDelegate.people.contacts;
        editViewController.peopleBio = self.appDelegate.people.bio;
        editViewController.peopleBirth = self.appDelegate.people.birth;
        
        editViewController.delegate = self;
    }
}

#pragma mark - AddItemControllerDelegate

- (void)editItemControllerDidSave:(EditViewController *)controller
                             name:(NSString *)name
                         lastName:(NSString *)lastName
                         birthday:(NSDate *)birthday
                         contacts:(NSString *)contacts
                              bio:(NSString *)bio;

{
    if ([name length] || [lastName length]) {
        self.appDelegate.people.name = name;
        self.appDelegate.people.surname = lastName;
        self.appDelegate.people.birth = birthday;
        self.appDelegate.people.contacts = contacts;
        self.appDelegate.people.bio = bio;
        
        [self.managedObjectContext save:nil];
        [self.fetchedResultsController performFetch:nil];
        [self updateOutlets];
    }
    [controller.navigationController dismissViewControllerAnimated:YES completion:nil];
}



#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // return YES for supported orientations
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#endif



- (IBAction)actionLogout:(id)sender {
    [self.appDelegate facebookLogout];
}
     
@end
