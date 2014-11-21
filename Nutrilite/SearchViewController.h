//
//  SearchViewController.h
//  SnapCalories
//
//  Created by Sindu on 9/8/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *foodSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *foodResultsView;

@property NSMutableArray *dataArray;
@property NSMutableArray *suggestArray;
@property NSMutableDictionary *dataDict;
@property NSMutableDictionary *favPortionCountDict;
@property NSMutableDictionary *favPortionIDDict;
@property NSString *searchText;
@property NSNumber *page;
@property NSNumber *nextPage;
@property NSString *foodID;
@property NSString *foodName;
@property NSString *logDate;
@property NSString *favPortionCount;
@property NSString *favPortionID;
@property int counter;
@property UIView *datePickerView;
@property UIDatePicker *datePicker;
@property NSDateFormatter *dateFormatter;

@property (strong, nonatomic) IBOutlet UIButton *prevButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *calendarButton;

- (IBAction)nextButtonClicked:(id)sender;
- (IBAction)prevButtonClicked:(id)sender;
- (IBAction)showDatePicker:(id)sender;

- (IBAction)favoriteButtonClicked:(id)sender;
- (IBAction)customButtonClicked:(id)sender;

@end
