//
//  AteTableViewCell.h
//  SnapCalories
//
//  Created by Sys Admin on 5/31/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AteTableViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView* foodImage;
@property(nonatomic, weak) IBOutlet UILabel* foodCalories;
@property(nonatomic, weak) IBOutlet UILabel* foodMealType;

@end
