//
//  AtePickerViewController.m
//  SnapCalories
//
//  Created by Sys Admin on 6/1/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "AtePickerViewController.h"

@interface AtePickerViewController ()

@end

@implementation AtePickerViewController

@synthesize mealType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      //  mealType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      //  mealType.frame=CGRectMake(self.view.bounds.size.width-100, self.view.bounds.size.height-70, 100, 60);
     //   [mealType setTitle:@"Breakfast" forState:UIControlStateNormal];
     //   [self.view addSubview:mealType];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(id)targetForAction:(SEL)action withSender:(id)sender
{
    NSLog(@"action");
    return sender;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"x");
}

-(void)takePicture
{
    mealType.hidden=YES;
    [super takePicture];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"xxx");
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
