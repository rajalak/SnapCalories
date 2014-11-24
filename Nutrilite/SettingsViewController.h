//
//  SettingsViewController.h
//  SnapCalories
//
//  Created by Sindu on 11/21/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;

@property(nonatomic, weak) IBOutlet UISlider* caloriesSlider;
@property(nonatomic, weak) IBOutlet UILabel* caloriesLabel;
@property(nonatomic, weak) IBOutlet UISlider* weightSlider;
@property(nonatomic, weak) IBOutlet UILabel* weightLabel;
@property(nonatomic, strong) IBOutlet UITableView* tableViewPA;

@property (nonatomic) int lastQuestionStep;
@property (nonatomic) int stepValue;

@property (nonatomic) int lastQuestionStepWeight;
@property (nonatomic) int stepValueWeight;

-(IBAction)logout:(id)sender;


@end

