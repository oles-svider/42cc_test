//
//  EditViewController.m
//  42cc_test
//
//  Created by oles on 4/7/13.
//  Copyright (c) 2013 42cc. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

@synthesize buttonSave;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textFieldName.text = self.peopleName;
    self.textFieldLastName.text = self.peopleLastName;
    self.textFieldEmail.text = self.peopleEmail;
    self.textViewBio.text = self.peopleBio;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:gmt];
    self.labelBirth.text = [formatter stringFromDate:self.peopleBirth];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

// Nothing to implement


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // nothing to do
}

- (IBAction)saveAction:(id)sender {
    
    // Check some fields
    if (![self validateEmailWithString:self.textFieldEmail.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email address error"
                                                        message:@"You must enter valid email address"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.textFieldEmail becomeFirstResponder];
        return;
    }
    if (!([self.textFieldName.text length] > 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No name entered"
                                                        message:@"Please, enter name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.textFieldName becomeFirstResponder];
        return;
    }
    
    [self.delegate editItemControllerDidSave:self
                                        name:self.textFieldName.text
                                    lastName:self.textFieldLastName.text
                                    birthday:self.peopleBirth
                                    contacts:self.textFieldEmail.text
                                         bio:self.textViewBio.text];
}

- (IBAction)cancelAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectBirthday:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 80, 0, 0);
    UIDatePicker *datePickerView = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    datePickerView.tag = 10;
    datePickerView.datePickerMode = UIDatePickerModeDate;
    datePickerView.date = self.peopleBirth;
    [datePickerView addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:datePickerView];
    
    [actionSheet addButtonWithTitle:@"Close"];
    [actionSheet setCancelButtonIndex:0];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 520)];
}

-(void)changeDate:(UIDatePicker *)picker{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone:gmt];
    self.labelBirth.text = [formatter stringFromDate:picker.date];
    self.peopleBirth = picker.date;
}

-(void)dismissActionSheet:(UIDatePicker *)picker{
    self.labelBirth.text = picker.date.description; // set text to date description
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField == self.textFieldName)
        [self.textFieldLastName becomeFirstResponder];
    else if (textField == self.textFieldLastName)
        [self.textFieldEmail becomeFirstResponder];
    else if (textField == self.textFieldEmail) {
        [self.textViewBio scrollRangeToVisible:self.textViewBio.selectedRange];
        [self.textViewBio becomeFirstResponder];
    }
    
    return NO; // We do not want UITextField to insert line-breaks.
}


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
