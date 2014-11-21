//
//  DetailViewController.h
//  SnapCalories
//
//  Created by Sindu on 11/18/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseDetailViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, NSXMLParserDelegate>

@property NSString *exerciseDesc;
@property NSString *exerciseTypeID;
@property NSMutableDictionary *levelDict;
@property NSString *exerciseID;
@property NSString *logDate;

@end
