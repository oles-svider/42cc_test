//
//  EditViewController.h
//  42cc_test
//
//  Created by oles on 4/3/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIImageView *imagePhoto;
@property (strong, nonatomic) IBOutlet UITextField *labelName;
@property (strong, nonatomic) IBOutlet UITextField *labelLastname;
@property (strong, nonatomic) IBOutlet UITextField *labelEmail;
@property (strong, nonatomic) IBOutlet UITextView *textViewBio;
@property (strong, nonatomic) IBOutlet UIButton *buttonBirthday;
- (IBAction)selectBirthday:(id)sender;
- (IBAction)selectPhoto:(id)sender;

@end
