//
//  NutritionFactsViewController.m
//  SnapCalories
//
//  Created by Sindu on 9/19/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "NutritionFactsViewController.h"
#import "FoodDetailViewController.h"

@interface NutritionFactsViewController ()

@end

@implementation NutritionFactsViewController

@synthesize mass, portionCount, nutrientDict, referenceDict, labels, portionDesc, foodName, perctLabels;
@synthesize foodNameLabel, portionDescLabel, fatCaloriesLabel;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    referenceDict = [[NSMutableDictionary alloc] init];
    referenceDict[@"fat"] = @"65";
    referenceDict[@"satFat"] = @"20";
    referenceDict[@"cholesterol"] = @"300";
    referenceDict[@"sodium"] = @"2400";
    referenceDict[@"carb"] = @"300";
    referenceDict[@"fiber"] = @"25";
    referenceDict[@"protein"] = @"50";
    referenceDict[@"vitA"] = @"5000";
    referenceDict[@"vitC"] = @"60";
    referenceDict[@"calcium"] = @"1000";
    referenceDict[@"iron"] = @"18";
    
    self.foodNameLabel.text = foodName;
    NSString *str = [portionCount stringByAppendingString:@" "];
    str = [str stringByAppendingString:portionDesc];
    str = [str stringByAppendingString:@" ("];
    str = [str stringByAppendingString:mass];
    self.portionDescLabel.text = [str stringByAppendingString:@"g)"];
    
    [self calculateNutrientValues];
    [self calculatePerctValues];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]
                                initWithTitle:@"Back"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(backButton)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backButton
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [UIView commitAnimations];
}

- (void) calculateNutrientValues
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: 3];

    double portionMass = [mass doubleValue];
    double count = [portionCount doubleValue];
    double nutrientValue;
    double value;
    
    for (int i=0; i<labels.count; i++)
    {
        UILabel *lbl = labels[i];
        nutrientValue = [[nutrientDict objectForKey:lbl.text] doubleValue];
        value = (count * portionMass * nutrientValue)/100;
        NSString *nutrientString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
        lbl.text = [nutrientString stringByAppendingString:@" g"];
    }
    
    double fatValue = [[nutrientDict objectForKey:@"fat"] doubleValue];
    double fatCalories = ((fatValue * 8.79) * portionMass * count) / 100;
    self.fatCaloriesLabel.text = [formatter stringFromNumber:[NSNumber numberWithFloat:fatCalories]];
}

- (void) calculatePerctValues
{
    NSNumberFormatter *perctFormatter = [[NSNumberFormatter alloc] init];
    [perctFormatter setNumberStyle:NSNumberFormatterNoStyle];
    [perctFormatter setMaximumFractionDigits:0];
    [perctFormatter setRoundingMode: 4];
    
    double portionMass = [mass doubleValue];
    double count = [portionCount doubleValue];
    double refValue;
    double value;
    double nutrientValue;
    
    for (int i=0; i<perctLabels.count; i++)
    {
        UILabel *lbl = perctLabels[i];
        refValue = [[referenceDict objectForKey:lbl.text] doubleValue];
        nutrientValue = [[nutrientDict objectForKey:lbl.text] doubleValue];
        value = (count * portionMass * nutrientValue)/100;
        value = (value / refValue) * 100;
        NSString *nutrientString = [perctFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
        lbl.text = [nutrientString stringByAppendingString:@"%"];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
