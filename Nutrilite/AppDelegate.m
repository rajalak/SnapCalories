//
//  AppDelegate.m
//  Nutrilite
//
//  Created by Sys Admin on 4/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"push notification");
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge ];
    
    SSKeychainQuery *keyChain = [SSKeychainQuery new];
    keyChain.service = APP_NAME;
    keyChain.account = APP_PUSH;

    NSError *error = nil;
    [keyChain fetch:&error];

#if TARGET_IPHONE_SIMULATOR
    [[DataModel sharedInstance] setPushNotification:@"SIMULATOR"];
#else
    [[DataModel sharedInstance] setPushNotification:keyChain.password];
#endif
    
    keyChain.account = APP_USER;
    
    if (![keyChain fetch:&error])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeNavigationBar"];
        self.window.rootViewController = viewController;
    }
    
    [[DataModel sharedInstance] setUserToken:keyChain.password];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout:) name:@"kLogoutNotification" object:nil];
    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"push arrive");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNotificationArrive" object:userInfo];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *device = [NSString stringWithFormat:@"%@",deviceToken];

    device=[device stringByReplacingOccurrencesOfString:@"<" withString:@""];
    device=[device stringByReplacingOccurrencesOfString:@">" withString:@""];
    device=[device stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[DataModel sharedInstance] setPushNotification:device];

    SSKeychainQuery *keyChain = [SSKeychainQuery new];
    keyChain.service = APP_NAME;
    keyChain.account = APP_PUSH;
    keyChain.password = device;

    NSError *error;
    [keyChain save:&error];
    
}

-(void)logout:(NSNotification*)info
{
    SSKeychainQuery *user = [[SSKeychainQuery alloc] init];
    user.service = APP_NAME;
    user.account = APP_USER;
    user.label = APP_USER;
    
    NSError *error;
    
    [user deleteItem:&error];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeNavigationBar"];
    
    [UIView
     transitionWithView:self.window
     duration:1.5
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void) {
         BOOL oldState = [UIView areAnimationsEnabled];
         [UIView setAnimationsEnabled:NO];
         self.window.rootViewController = viewController;
         [UIView setAnimationsEnabled:oldState];
     }
     completion:nil];
    
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
