//
//  LoginViewControllerTableViewController.m
//  Nutrilite
//
//  Created by Sys Admin on 4/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "LoginViewControllerTableViewController.h"
#import "AppDelegate.h"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/servlet/";

@interface LoginViewControllerTableViewController ()

@end

@implementation LoginViewControllerTableViewController

@synthesize user;
@synthesize password;

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
    [user becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)login:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.responseSerializer=[AFXMLDictionaryResponseSerializer serializer];
        
        NSString *stringURL = [BaseURLString stringByAppendingString:@"loginUser"];
        
        NSDictionary *parameters = @{@"userName": user.text, @"password": password.text, @"appleDeviceToken": [[DataModel sharedInstance] pushNotification]};
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        [manager GET:stringURL
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                  NSLog(@"SUCESS: %@", responseObject);
                 
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                 if ([responseObject isKindOfClass:[NSDictionary class]]) {
                     if ([[responseObject objectForKey:@"result"] intValue]>0) {
                         
                         SSKeychainQuery *token = [[SSKeychainQuery alloc] init];
                         token.password = [responseObject objectForKey:@"result"];
                         token.service = APP_NAME;
                         token.account = APP_USER;
                         token.label = APP_USER;
                         
                         [[DataModel sharedInstance] setUserToken:[responseObject objectForKey:@"result"]];
                         
                         NSError *error;
                         if ([token save:&error])
                         {
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
                             UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
                             [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
                         }
                     }
                     else
                     {
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                             message:@"Invalid Login"
                                                                            delegate:self
                                                                   cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                         
                         [alertView show];
                     }
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                     message:@"Invalid Login"
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"OK", nil];
                 
                 [alertView show];
                 
             }
         ];
    });
}

-(IBAction) textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}
@end
