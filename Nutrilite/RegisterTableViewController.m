//
//  RegisterTableViewController.m
//  SnapCalories
//
//  Created by Sys Admin on 5/2/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "RegisterAccountTableViewController.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

@synthesize selectedIndexPath;
@synthesize gender;
@synthesize weight;
@synthesize heighFeet;
@synthesize heighinches;
@synthesize birthDate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath] tag]==9) {
        [[tableView cellForRowAtIndexPath:selectedIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        selectedIndexPath=[indexPath copy];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"CreateAccount"])
    {
        RegisterAccountTableViewController *registerAccount = [segue destinationViewController];
        
        registerAccount.gender              = (gender.selectedSegmentIndex==0) ? @"M" : @"F";
        registerAccount.weight              = weight.text;
        registerAccount.heighFeet           = heighFeet.text;
        registerAccount.heighInches         = heighinches.text;
        registerAccount.terms               = @"ON";
        registerAccount.activationToken     = @"";
        registerAccount.promoCode           = @"NHRJ83";
        registerAccount.securityQuestion    = @"What city where you born in?";
        registerAccount.securityAnswer      = @"brazil";
        registerAccount.birthMonth          = [birthDate.text substringWithRange:NSMakeRange(0,2)];
        registerAccount.birthDay            = [birthDate.text substringWithRange:NSMakeRange(3,2)];
        registerAccount.birthYear           = [birthDate.text substringWithRange:NSMakeRange(6,4)];
               
        
        if (selectedIndexPath.row == 0)  registerAccount.lifeStyle = @"sedentary";
        if (selectedIndexPath.row == 1)  registerAccount.lifeStyle = @"light";
        if (selectedIndexPath.row == 3)  registerAccount.lifeStyle = @"moderate";
        if (selectedIndexPath.row == 2)  registerAccount.lifeStyle = @"veryActive";
        if (selectedIndexPath.row == 4)  registerAccount.lifeStyle = @"extraActive";
    }
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    
}

- (IBAction)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == birthDate)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/yyyy";
        NSDate *date = [formatter dateFromString:birthDate.text];
        
        if ((date == nil) || (birthDate.text.length < 10))
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Invalid BirthDate, use format(mm/dd/yyyy)"
                                                               delegate:self
                                                      cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            
            [alertView show];
        }
        else
            birthDate.text = [formatter stringFromDate:date];
    }
}


@end
