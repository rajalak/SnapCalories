//
//  LoginViewControllerTableViewController.h
//  Nutrilite
//
//  Created by Sys Admin on 4/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewControllerTableViewController : UITableViewController

@property(nonatomic, weak) IBOutlet UITextField *user;
@property(nonatomic, weak) IBOutlet UITextField *password;

- (IBAction)login:(id)sender;
- (IBAction)textFieldReturn:(id)sender;

@end
