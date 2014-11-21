//
//  FoodLog.h
//  SnapCalories
//
//  Created by Sindu on 9/22/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodLog : NSObject

@property NSString* foodID;
@property NSString* portionDesc;
@property NSString* portionCount;
@property NSString* mealTypeID;
@property NSString* recordID;
@property NSString* calories;
@property NSString* foodName;

- (id) initWithValues:(NSString *)pfoodID withPortionDesc:(NSString *)pportionDesc withPortionCount:(NSString *)pportionCount withMealTypeID:(NSString *)pmealTypeID withRecordID:(NSString *)precordID withCalories:(NSString *)pcalories withFoodName:(NSString *)pfoodName;
@end
