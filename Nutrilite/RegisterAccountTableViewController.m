//
//  RegisterAccountTableViewController.m
//  SnapCalories
//
//  Created by Sys Admin on 5/11/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "RegisterAccountTableViewController.h"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/saveRegistration.do";

@interface RegisterAccountTableViewController ()

@end

@implementation RegisterAccountTableViewController

@synthesize firstName;
@synthesize lastName;
@synthesize email;
@synthesize password;
@synthesize passwordConfirm;

@synthesize securityAnswer;
@synthesize securityQuestion;

@synthesize gender;
@synthesize birthDay;
@synthesize birthMonth;
@synthesize birthYear;

@synthesize weight;
@synthesize heighFeet;
@synthesize heighInches;
@synthesize lifeStyle;

@synthesize activationToken;

@synthesize terms;
@synthesize promoCode;

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

#pragma makr - Create Account

-(IBAction)createAccount:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];        
        NSString *stringURL = BaseURLString;
        
        NSDictionary *parameters = @{@"userName":           email.text,
                                     @"password":           password.text,
                                     @"firstName":          firstName.text,
                                     @"lastName":           lastName.text,
                                     @"gender":             gender,
                                     @"birthMonth":         birthMonth,
                                     @"birthDay":           birthDay,
                                     @"birthYear":          birthYear,
                                     @"secQuestion":        securityQuestion,
                                     @"secAnswer":          securityAnswer,
                                     @"heightFt":           heighFeet,
                                     @"heightIn":           heighInches,
                                     @"weight":             weight,
                                     @"activationToken":    activationToken,
                                     @"promoCode":          promoCode,
                                     @"terms":              terms,
                                     @"lifestyle":          lifeStyle,
                                     @"password2":          passwordConfirm.text,
                                     @"ios_device":         @"true"
                                     };
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [manager POST:stringURL
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSLog(@"SUCESS: %@", responseObject);
                 
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 
                 NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                             
                 if ([responseStr length] > 0) {
                     if ([responseStr rangeOfString:@"Success"].location != NSNotFound)
                     {
                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                         UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                         [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
                     }
                     else
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                             message:@"E-mail address is taken. Please try again"
                                                                            delegate:self
                                                                   cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                         
                         [alertView show];
                     }
                 }
                 
                 NSLog(@"XML..: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding] );
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"failure: %@", operation);
                 
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"Not possible create your account. Please try again"
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"OK", nil];
                 
                 [alertView show];
                 
             }
         ];
    });
}

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
@end
