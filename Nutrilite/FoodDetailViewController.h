//
//  FoodDetailViewController.h
//  SnapCalories
//
//  Created by Sindu on 9/9/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSString *foodID;
@property NSString *portionID;
@property NSString *foodName;
@property NSString *logDate;
@property NSString *proteinValue;
@property NSString *fatValue;
@property NSString *carbValue;
@property NSString *calorieValue;
@property NSString *selectedMass;
@property NSString *mealTypeID;
@property NSString *recordID;
@property NSString *userAction;
@property NSString *editPortionCount;
@property NSString *editPortionDesc;
@property NSString *editPortionID;
@property BOOL singlePortion;

@property (strong, nonatomic) IBOutlet UILabel *carbLabel;
@property (strong, nonatomic) IBOutlet UILabel *proteinLabel;
@property (strong, nonatomic) IBOutlet UILabel *fatLabel;

@property (strong, nonatomic) IBOutlet UILabel *caloriesLabel;
@property (strong, nonatomic) IBOutlet UITextField *portionCount;
@property (strong, nonatomic) IBOutlet UITextField *portionDesc;
@property (strong, nonatomic) IBOutlet UITextField *mealType;

@property (strong, nonatomic) IBOutlet UIPickerView *portionDescPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *mealTypePicker;
@property (strong, nonatomic) IBOutlet UIButton *addSearchButton;
@property (strong, nonatomic) IBOutlet UIButton *addDiaryButton;

@property NSMutableDictionary *portionDescDict;
@property NSMutableDictionary *portionMassDict;
@property NSMutableDictionary *portionIDDict;
@property NSMutableArray *portionDescArray;
@property NSMutableDictionary *nutrientDict;

@property NSMutableArray *mealTypeArray;
@property NSMutableDictionary *mealTypeDict;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)addFoodAndSearch:(id)sender;
- (IBAction)addFoodAndDiary:(id)sender;
- (IBAction)showFacts:(id)sender;


@end
