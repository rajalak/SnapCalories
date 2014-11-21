//
//  IAteViewControllerTableViewController.h
//  SnapCalories
//
//  Created by Sys Admin on 5/10/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>

@interface AteTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, strong) NSMutableArray* dataset;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;

- (IBAction)takePhoto:(id)sender;

@end
