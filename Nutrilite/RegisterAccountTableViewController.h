//
//  RegisterAccountTableViewController.h
//  SnapCalories
//
//  Created by Sys Admin on 5/11/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterTableViewController.h"

@interface RegisterAccountTableViewController : UITableViewController

@property(nonatomic, weak) IBOutlet UITextField *firstName;
@property(nonatomic, weak) IBOutlet UITextField *lastName;
@property(nonatomic, weak) IBOutlet UITextField *email;
@property(nonatomic, weak) IBOutlet UITextField *password;
@property(nonatomic, weak) IBOutlet UITextField *passwordConfirm;

@property(nonatomic, copy) NSString *securityQuestion;
@property(nonatomic, copy) NSString *securityAnswer;

@property(nonatomic, copy) NSString *gender;

@property(nonatomic, copy) NSString *birthDay;
@property(nonatomic, copy) NSString *birthMonth;
@property(nonatomic, copy) NSString *birthYear;

@property(nonatomic, copy) NSString *weight;
@property(nonatomic, copy) NSString *heighFeet;
@property(nonatomic, copy) NSString *heighInches;
@property(nonatomic, copy) NSString *lifeStyle;
@property(nonatomic, copy) NSString *activationToken;
@property(nonatomic, copy) NSString *terms;
@property(nonatomic, copy) NSString *promoCode;

-(IBAction)createAccount:(id)sender;

- (IBAction)textFieldReturn:(id)sender;

@end
