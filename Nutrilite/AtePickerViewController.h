//
//  AtePickerViewController.h
//  SnapCalories
//
//  Created by Sys Admin on 6/1/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AtePickerViewController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) UIButton* mealType;

-(void)takePicture;

@end
