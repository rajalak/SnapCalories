//
//  FoodLog.m
//  SnapCalories
//
//  Created by Sindu on 9/22/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "FoodLog.h"

@implementation FoodLog

@synthesize foodID, portionCount, portionDesc, mealTypeID, recordID, calories, foodName;


-(id) initWithValues:(NSString *)pfoodID withPortionDesc:(NSString *)pportionDesc withPortionCount:(NSString *)pportionCount withMealTypeID:(NSString *)pmealTypeID withRecordID:(NSString *)precordID withCalories:(NSString *)pcalories withFoodName:(NSString *)pfoodName
{
    self = [super init];
    self.foodID = pfoodID;
    self.portionDesc = pportionDesc;
    self.portionCount = pportionCount;
    self.mealTypeID = pmealTypeID;
    self.recordID = precordID;
    self.calories = pcalories;
    self.foodName = pfoodName;
    
    return self;
}
@end
