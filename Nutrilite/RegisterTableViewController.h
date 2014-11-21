//
//  RegisterTableViewController.h
//  SnapCalories
//
//  Created by Sys Admin on 5/2/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterTableViewController : UITableViewController


@property(nonatomic, weak) IBOutlet UISegmentedControl *gender;
@property(nonatomic, weak) IBOutlet UITextField *birthDate;
@property(nonatomic, weak) IBOutlet UITextField *weight;
@property(nonatomic, weak) IBOutlet UITextField *heighFeet;
@property(nonatomic, weak) IBOutlet UITextField *heighinches;
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

- (IBAction)textFieldReturn:(id)sender;

- (IBAction)textFieldDidEndEditing:(UITextField *)textField;
@end
