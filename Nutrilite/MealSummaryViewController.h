//
//  MealSummaryViewController.h
//  SnapCalories
//
//  Created by Sindu on 9/22/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealSummaryViewController : UIViewController <NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSString* logDate;
@property NSString* mealTypeID;
@property NSString* foodID;
@property NSString* portionDesc;
@property NSString* portionCount;
@property NSString* recordID;
@property NSString* calories;
@property NSString* foodName;

@property int counter;
@property BOOL isMealType;

@property NSMutableDictionary* dataDict;
@property NSMutableArray* sectionArray;
@property NSMutableDictionary* mealTypeDict;

@property UIView *datePickerView;
@property UIDatePicker *datePicker;
@property NSDateFormatter *dateFormatter;

@property (strong, nonatomic) IBOutlet UITableView *mealSummaryView;
@property (strong, nonatomic) IBOutlet UIButton *calendarButton;
@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (IBAction)showDatePicker:(id)sender;
- (IBAction)prevButtonClicked:(id)sender;
- (IBAction)nextButtonClicked:(id)sender;

@end
