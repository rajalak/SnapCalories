//
//  SettingsTableViewController.m
//  SnapCalories
//
//  Created by Sys Admin on 6/10/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "SettingsTableViewController.h"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/servlet/";

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize selectedIndexPath, caloriesSlider, caloriesLabel, weightSlider, weightLabel, tableViewPA;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self selectSettings];
    
    //set the calories
    
    self.stepValue = 25.0f;
    
    self.lastQuestionStep = (self.caloriesSlider.value) / self.stepValue;
    
    //set the weight
    
    self.stepValueWeight = 1.0f;
    
    self.lastQuestionStepWeight = (self.weightSlider.value) / self.stepValueWeight;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedIndexPath.row==indexPath.row) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath] tag]==9) {
        [[tableView cellForRowAtIndexPath:selectedIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        selectedIndexPath=[indexPath copy];
        [self updateSettingsServer];
     }
}

#pragma mark - Logout

-(IBAction)logout:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kLogoutNotification" object:nil];
}

#pragma mark - Slider Calories

-(IBAction)didChangeCaloriesEnd:(id)sender
{
    [self updateSettingsServer];
}

-(IBAction)didChangeCalories:(id)sender
{
    float newStep = roundf((caloriesSlider.value) / self.stepValue);
    
    self.caloriesSlider.value = newStep * self.stepValue;
    
    NSUInteger total = self.caloriesSlider.value;
    
    NSString* goal = [NSString stringWithFormat:@"%d Cal",total];
    
    caloriesLabel.text = goal;
}

#pragma mark - Slider Weight

-(IBAction)didChangeWeightEnd:(id)sender
{
    [self updateSettingsServer];
}

-(IBAction)didChangeWeight:(id)sender
{
    float newStep = roundf((weightSlider.value) / self.stepValueWeight);
    
    self.weightSlider.value = newStep * self.stepValueWeight;
    
    NSUInteger total = self.weightSlider.value;
    
    NSString* goal = [NSString stringWithFormat:@"%d Cal",total];
    
    weightLabel.text = goal;
}

#pragma mark - Server API

-(void)updateSettingsServer
{
    NSString *url = [BaseURLString stringByAppendingString:@"updateUserInfo"];
    
    NSString *lifestyle;
    if (selectedIndexPath.row == 0)  lifestyle = @"sedentary";
    if (selectedIndexPath.row == 1)  lifestyle = @"light";
    if (selectedIndexPath.row == 3)  lifestyle = @"moderate";
    if (selectedIndexPath.row == 2)  lifestyle = @"veryActive";
    if (selectedIndexPath.row == 4)  lifestyle = @"extraActive";
    
    NSUInteger weight = self.weightSlider.value;
    NSUInteger goal = self.caloriesSlider.value;
    
    NSDictionary* parameters = @{
                                 @"goal" : [NSString stringWithFormat:@"%d", goal],
                                 @"weight" : [NSString stringWithFormat:@"%d", weight],
                                 @"lifestyle" : lifestyle,
                                 @"token" : [[DataModel sharedInstance] userToken]
                                };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFXMLDictionaryResponseSerializer serializer];
    
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation* operation, id responseObject) {
             
         }
         failure:^(AFHTTPRequestOperation* operation, NSError* error) {
         }];

}

#pragma mark - Database

-(void)selectSettings
{
   /* __block NSMutableArray* result = [NSMutableArray array];

    [[DataModel sharedInstance] executeStatement:^(FMDatabase* db) {
    
        FMResultSet *resultSet = [db executeQuery:@"select * from goal;"];
    
        while ([resultSet next]) {
            NSDictionary *dictionary = [resultSet resultDictionary];
            [result addObject:[dictionary copy]];
        }
        [resultSet close];
    }];
    
    NSDictionary* record = [result firstObject];*/
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFXMLDictionaryResponseSerializer serializer];
    
    NSString *stringURL = [BaseURLString stringByAppendingString:@"getUserSummary"];
    
    NSDictionary *parameters = @{@"token": [[DataModel sharedInstance] userToken]};
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:stringURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary* data = [responseObject copy];             
      
             NSDictionary* settingsArray = [data objectForKey:@"settings"];
             NSString *lifestyle;
             
             caloriesSlider.value = [[settingsArray objectForKey:@"_goal"]floatValue];
             weightSlider.value = [[settingsArray objectForKey:@"_weight"]floatValue];
             lifestyle = [settingsArray objectForKey:@"_lifestyle"];
             
             NSUInteger physicalActivity = 0;
             if ([lifestyle  isEqual: @"sedentary"]) physicalActivity = 0;
             if ([lifestyle  isEqual: @"light"]) physicalActivity = 1;
             if ([lifestyle  isEqual: @"moderate"]) physicalActivity = 3;
             if ([lifestyle  isEqual: @"veryActive"]) physicalActivity = 2;
             if ([lifestyle  isEqual: @"extraActive"]) physicalActivity = 4;

            //set Calories
    
             NSUInteger totalCalories = self.caloriesSlider.value;
             NSString* goal = [NSString stringWithFormat:@"%d Cal",totalCalories];
             caloriesLabel.text = goal;
    
             //set Weight
    
             NSUInteger totalWeight = self.weightSlider.value;
             NSString* weight = [NSString stringWithFormat:@"%d lbs",totalWeight];
             weightLabel.text = weight;
    
             //Physical activity
             
             selectedIndexPath = [NSIndexPath indexPathForRow:physicalActivity inSection:2];
             
            
             UITableViewCell* cell = [[super tableView] cellForRowAtIndexPath:selectedIndexPath];
             [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
              
         }
     ];

}

/*- (void)updateCaloriesLocal:(NSString*)goal
{
    [[DataModel sharedInstance] executeStatement:^(FMDatabase* db) {
        
        [db executeUpdate:@"update goal set calories = ? ", goal];
        
    }];
}

- (void)updateWeightLocal:(NSString*)weight
{
    [[DataModel sharedInstance] executeStatement:^(FMDatabase* db) {
        
        [db executeUpdate:@"update goal set weight = ? ", weight];
        
    }];
}

- (void)updatePhysicalActivity:(NSString*)physicalActivity
{
    [[DataModel sharedInstance] executeStatement:^(FMDatabase* db) {
        
        [db executeUpdate:@"update goal set physicalActivity = ? ", physicalActivity];
        
    }];
}*/



@end
