//
//  NutritionFactsViewController.h
//  SnapCalories
//
//  Created by Sindu on 9/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NutritionFactsViewController : UIViewController

@property NSString *mass;
@property NSString *portionCount;
@property NSString *portionDesc;
@property NSString *foodName;

@property NSMutableDictionary *nutrientDict;
@property NSMutableDictionary *referenceDict;

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labels;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *perctLabels;

@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *portionDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatCaloriesLabel;




@end
