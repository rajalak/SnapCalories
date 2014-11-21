//
//  FirstViewController.h
//  Nutrilite
//
//  Created by Sys Admin on 4/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPlotChart.h"
#import "JSON.h"

@interface FirstViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *caloriesRemainLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalLabel;
@property (strong, nonatomic) IBOutlet UILabel *intakeLabel;
@property (strong, nonatomic) IBOutlet UILabel *burnedLabel;
@property (strong, nonatomic) IBOutlet UILabel *netLabel;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
