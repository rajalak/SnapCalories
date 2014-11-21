//
//  AppDelegate.h
//  Nutrilite
//
//  Created by Sys Admin on 4/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SSKeychain/SSKeychain.h>
#import <SSKeychain/SSKeychainQuery.h>

#define APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
#define APP_USER @"USER"
#define APP_PUSH @"PUSH"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end
