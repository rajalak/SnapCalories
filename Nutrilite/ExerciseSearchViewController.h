//
//  ExerciseSearchViewController.h
//  SnapCalories
//
//  Created by Sindu on 11/18/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseSearchViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *exerciseSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *exerciseTableView;

@property NSMutableArray *dataArray;
@property NSMutableDictionary *dataDict;
@property NSString *searchText;
@property NSString *logDate;
@property NSDateFormatter *dateFormatter;

@end
