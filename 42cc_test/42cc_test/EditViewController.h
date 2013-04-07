//
//  EditViewController.h
//  42cc_test
//
//  Created by oles on 4/7/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditItemControllerDelegate;


@interface EditViewController : UITableViewController <UITextFieldDelegate>

- (IBAction)saveAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)selectBirthday:(id)sender;

@property (weak, nonatomic) id <EditItemControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *labelBirth;
@property (strong, nonatomic) IBOutlet UITextView *textViewBio;
@property (strong, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (strong, nonatomic) IBOutlet UITextField *textFieldLastName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldName;


@property (strong, nonatomic) NSString *peopleName;
@property (strong, nonatomic) NSString *peopleLastName;
@property (strong, nonatomic) NSString *peopleEmail;
@property (strong, nonatomic) NSString *peopleBio;
@property (strong, nonatomic) NSDate *peopleBirth;



@end


@protocol EditItemControllerDelegate <NSObject>

- (void)editItemControllerDidSave:(EditViewController *)controller
                             name:(NSString *)name
                         lastName:(NSString *)lastName
                         birthday:(NSDate *)birthday
                         contacts:(NSString *)contacts
                              bio:(NSString *)bio;

@end
