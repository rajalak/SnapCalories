//
//  FirstViewController.m
//  Nutrilite
//
//  Created by Sys Admin on 4/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "FirstViewController.h"

#define kQuery              @"query"
#define kResults            @"results"
#define kQuote              @"quote"
#define kCount              @"count"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/servlet/";
@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize caloriesRemainLabel, goalLabel, intakeLabel, burnedLabel, netLabel, webView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"DATA.json"];
    NSString *jsonString = [NSString stringWithContentsOfFile:sampleFile encoding:NSUTF8StringEncoding error:nil];
    
    NSOrderedSet *arrHistoricData = [NSOrderedSet orderedSetWithArray:[[[[jsonString JSONValue] objectForKey:kQuery] objectForKey:kResults] objectForKey:kQuote]];

    DPlotChart *plotChart = [[DPlotChart alloc] initWithFrame:CGRectMake(10, 200, 250, 300)];
    [plotChart createChartWith:arrHistoricData];
    [self.view addSubview:plotChart];*/

}

- (void) viewWillAppear:(BOOL)animated
{
    [self selectUserSummary];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.nutrihand.com/Nutrihand/calorieGoalChart.do?token=%@", [[DataModel sharedInstance] userToken]];
    
	NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) selectUserSummary
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFXMLDictionaryResponseSerializer serializer];
    
    NSString *stringURL = [BaseURLString stringByAppendingString:@"getUserSummary"];
    
    NSDictionary *parameters = @{@"token": [[DataModel sharedInstance] userToken]};
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:stringURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary* data = [responseObject copy];
             
             NSDictionary* settingsArray = [data objectForKey:@"settings"];
             NSDictionary *todayArray = [data objectForKey:@"today"];
             
             goalLabel.text = [settingsArray objectForKey:@"_goal"];
             
             NSString *consumed = [todayArray objectForKey:@"_caloriesConsumed"];
             intakeLabel.text = [NSString stringWithFormat:@"+%@",consumed];
             NSString *burned = [todayArray objectForKey:@"_caloriesBurned"];
             burnedLabel.text = [NSString stringWithFormat:@"-%@", burned];
             
             NSInteger totalCalories = [consumed integerValue];
             NSInteger caloriesBurned = [burned integerValue];
             netLabel.text = [NSString stringWithFormat:@"%d", (totalCalories - caloriesBurned)];
             
             NSInteger calorieGoal = [[goalLabel text] integerValue];
             caloriesRemainLabel.text = [NSString stringWithFormat:@"%d Remaining Today", (calorieGoal - totalCalories)];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             
         }
     ];

}
@end
