//
//  FoodDetailViewController.m
//  SnapCalories
//
//  Created by Sindu on 9/9/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "FoodDetailViewController.h"
#import "SearchViewController.h"
#import "NutritionFactsViewController.h"
#import "MealSummaryViewController.h"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/servlet/";

@interface FoodDetailViewController ()

@end

@implementation FoodDetailViewController

@synthesize foodID, foodName, logDate,  portionDescDict, portionDescArray, portionMassDict, portionIDDict, nutrientDict, portionDescPicker, addDiaryButton, addSearchButton;
@synthesize mealTypeArray, mealTypeDict, mealTypePicker, mealTypeID, portionID, recordID, userAction, selectedMass, editPortionCount, editPortionDesc, editPortionID;
@synthesize portionCount, portionDesc, mealType, proteinValue, fatValue, carbValue, calorieValue, proteinLabel, fatLabel, carbLabel, caloriesLabel, singlePortion;

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

    portionDescDict = [[NSMutableDictionary alloc]init];
    portionDescArray = [[NSMutableArray alloc]init];
    portionMassDict = [[NSMutableDictionary alloc]init];
    portionIDDict = [[NSMutableDictionary alloc]init];
    nutrientDict = [[NSMutableDictionary alloc]init];
    
    mealTypeDict = [[NSMutableDictionary alloc]init];
    mealTypeArray = [[NSMutableArray alloc] initWithObjects:@"Breakfast", @"Snack1", @"Lunch", @"Snack2", @"Dinner", @"Snack3",  nil];
    mealTypeDict[@"Breakfast"] = @"1";
    mealTypeDict[@"Snack1"] = @"2";
    mealTypeDict[@"Lunch"] = @"3";
    mealTypeDict[@"Snack2"] = @"4";
    mealTypeDict[@"Dinner"] = @"5";
    mealTypeDict[@"Snack3"] = @"6";
    
    portionDescPicker = [[UIPickerView alloc] init];
    portionDescPicker.delegate = self;
    portionDescPicker.dataSource = self;
    portionDescPicker.showsSelectionIndicator = YES;
    
    mealTypePicker = [[UIPickerView alloc] init];
    mealTypePicker.delegate = self;
    mealTypePicker.dataSource = self;
    mealTypePicker.showsSelectionIndicator = YES;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem *flexibleSpace =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(pickerDoneClicked)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, flexibleSpace, nil]];

    
    /*UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Cancel"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(cancelButton)];
    self.navigationItem.rightBarButtonItem = saveButton;*/
    
    [self getFoodDetails];
    
    self.portionDesc.inputView = portionDescPicker;
    self.portionDesc.inputAccessoryView = keyboardDoneButtonView;
    self.portionDescPicker.tag = 1;
    
    self.mealType.inputView = mealTypePicker;
    self.mealType.inputAccessoryView = keyboardDoneButtonView;
    self.mealTypePicker.tag = 2;
    
    self.portionCount.inputAccessoryView = keyboardDoneButtonView;
    
    if ([[self userAction] isEqual: @"add"])
    {
        if ([self editPortionCount] != nil)
            self.portionCount.text = [self editPortionCount];
        else
            self.portionCount.text = @"1";
        self.mealType.text = [mealTypeArray objectAtIndex:0];
        self.mealTypeID = @"1";
    }
    else
    {
        self.mealType.hidden = YES;
        self.portionCount.text = [self editPortionCount];
        [addSearchButton setTitle:@"Update" forState:UIControlStateNormal];
        [addDiaryButton setTitle:@"Delete" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count = 0;
    if (pickerView.tag == 1)
        count = portionDescArray.count;
    else if (pickerView.tag == 2)
        count = mealTypeArray.count;
    return count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if (pickerView.tag == 1)
        title = portionDescArray[row];
    else if (pickerView.tag == 2)
        title = mealTypeArray[row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
    {
        self.portionDesc.text = [portionDescArray objectAtIndex:row];
    }
    else if (pickerView.tag == 2)
    {
        NSString *mealTypeStr = [mealTypeArray objectAtIndex:row];
        self.mealType.text = mealTypeStr;
        self.mealTypeID = [mealTypeDict objectForKey:mealTypeStr];
    }
}

- (void) pickerDoneClicked
{
    [self.portionDesc resignFirstResponder];
    [self.mealType resignFirstResponder];
    [self.portionCount resignFirstResponder];
    [self rescale];
}

-(void) cancelButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
    [self rescale];
}

- (IBAction)addFoodAndSearch:(id)sender
{
    NSString *label = [addSearchButton currentTitle];
    if ([label isEqualToString:@"Update"])
    {
        [self updateFood];
    }
    else
    {
        [self addFood];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)addFoodAndDiary:(id)sender
{
    NSString *label = [addDiaryButton currentTitle];
    if ([label isEqualToString:@"Delete"])
    {
        [self deleteFood];
    }
    else
    {
        [self addFood];
        UIStoryboard* storyboard = self.storyboard;
        MealSummaryViewController  *mealVC = [storyboard instantiateViewControllerWithIdentifier:@ "MealSummaryViewController"];
        mealVC.logDate = self.logDate;
        [self.navigationController pushViewController:mealVC animated:YES];
    }
}

- (IBAction)showFacts:(id)sender
{
    UIStoryboard* storyboard = self.storyboard;
    NutritionFactsViewController  *factsVC = [storyboard instantiateViewControllerWithIdentifier:@ "NutritionFactsViewController"];
    
    factsVC.title = @"Nutritional Facts";
    factsVC.foodName = [self foodName];
    factsVC.mass = [self selectedMass];
    factsVC.portionCount = [self.portionCount text];
    factsVC.portionDesc = [self.portionDesc text];
    factsVC.nutrientDict = [self nutrientDict];
    
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    
    //[self.view addSubview:factsVC.view];
    [self.navigationController pushViewController:factsVC animated:YES];

    [UIView commitAnimations];
}

-(void)getFoodDetails
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer=[AFXMLDictionaryResponseSerializer serializer];
    
    
    NSString *stringURL = [BaseURLString stringByAppendingString:@"getFoodDetails"];
    
    NSDictionary *parameters = @{@"id": foodID,
                                 @"ios": @"true",
                                 @"version": @"2"};
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [manager GET:stringURL
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSDictionary  *data = [responseObject copy];
             
             NSDictionary *foodArray = [data objectForKey:@"food"];
             NSDictionary *portionsArray = [foodArray objectForKey:@"portions"];
             NSDictionary *portionObj = [portionsArray objectForKey:@"portion"];
             NSLog(@"length %d", [portionObj count]);
             NSEnumerator *enumerator  = portionObj.objectEnumerator;
             NSDictionary *detailsArray;
             int i=0;
             while ((detailsArray = enumerator.nextObject) != nil)
             {
                 // when multiple portions are present
                 if ([detailsArray isKindOfClass:[NSDictionary class]])
                 {
                     NSString *foodPortionID = [detailsArray objectForKey:@"_id"];
                     NSString *portionDescStr = [detailsArray objectForKey:@"_name"];
                     NSString *mass = [detailsArray objectForKey:@"_mass"];
                     portionDescDict[portionDescStr] = foodPortionID;
                     portionDescArray[i] = portionDescStr;
                     portionMassDict[foodPortionID] = mass;
                     portionIDDict[foodPortionID] = portionDescStr;
                     i = i + 1;
                 }
                 else
                 {
                     singlePortion = YES;
                     break;
                 }
             }
             if (singlePortion)
             {
                 NSString *foodPortionID = [portionObj objectForKey:@"_id"];
                 NSString *portionDescStr = [portionObj objectForKey:@"_name"];
                 NSString *mass = [portionObj objectForKey:@"_mass"];
                 portionDescDict[portionDescStr] = foodPortionID;
                 portionDescArray[i] = portionDescStr;
                 portionMassDict[foodPortionID] = mass;
                 portionIDDict[foodPortionID] = portionDescStr;
                 singlePortion = NO;
             }
             NSDictionary *nutrientsArray = [foodArray objectForKey:@"nutrients"];
             NSDictionary *nutrientObj = [nutrientsArray objectForKey:@"nutrient"];
             enumerator = nutrientObj.objectEnumerator;
             while ((detailsArray = enumerator.nextObject) != nil)
             {
                 NSString *id = [detailsArray objectForKey:@"_id"];
                
                 if ([id isEqualToString:@"203"])
                 {
                     self.proteinValue = [detailsArray objectForKey:@"_value"];
                     nutrientDict[@"protein"] = [detailsArray objectForKey:@"_value"];
                 }
                 else if ([id isEqualToString:@"204"])
                 {
                     self.fatValue = [detailsArray objectForKey:@"_value"];
                     nutrientDict[@"fat"] = [detailsArray objectForKey:@"_value"];
                 }
                 else if ([id isEqualToString:@"205"])
                 {
                     self.carbValue = [detailsArray objectForKey:@"_value"];
                     nutrientDict[@"carb"] = [detailsArray objectForKey:@"_value"];
                 }
                 else if ([id isEqualToString:@"208"])
                 {
                     self.calorieValue = [detailsArray objectForKey:@"_value"];
                     nutrientDict[@"calories"] = [detailsArray objectForKey:@"_value"];
                 }
                 else if ([id isEqualToString:@"606"])
                     nutrientDict[@"satFat"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"601"])
                     nutrientDict[@"cholesterol"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"307"])
                     nutrientDict[@"sodium"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"291"])
                     nutrientDict[@"fiber"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"269"])
                     nutrientDict[@"sugar"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"318"])
                     nutrientDict[@"vitA"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"401"])
                     nutrientDict[@"vitC"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"301"])
                     nutrientDict[@"calcium"] = [detailsArray objectForKey:@"_value"];
                 else if ([id isEqualToString:@"303"])
                     nutrientDict[@"iron"] = [detailsArray objectForKey:@"_value"];
                 
             }
             [portionDescPicker reloadAllComponents];
             
             if ([[self userAction] isEqual: @"add"])
             {
                 if ([self editPortionID] != nil)
                     self.portionDesc.text = [portionIDDict objectForKey:self.editPortionID];
                 else
                     self.portionDesc.text = [portionDescArray objectAtIndex:0];
             }
             else
                 self.portionDesc.text = [self editPortionDesc];
             
             self.portionID = [portionDescDict objectForKey:self.portionDesc.text];
             self.selectedMass = [portionMassDict objectForKey:self.portionID];
             [self rescale];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             
         }
     ];
    
}


-(void) rescale
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: 3];

    NSString *key = self.portionDesc.text;
    NSString *foodPortionID = [portionDescDict objectForKey:key];
    self.portionID = foodPortionID;
    double mass = [[portionMassDict objectForKey:foodPortionID] doubleValue];
    double count = [[portionCount text] doubleValue];
    self.selectedMass = [portionMassDict objectForKey:foodPortionID];
    
    double value = (count * mass * [self.proteinValue doubleValue])/100;
    NSString *nutrientString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    self.proteinLabel.text = [nutrientString stringByAppendingString:@" g"];
       
    value = (count * mass * [self.fatValue doubleValue])/100;
    nutrientString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    self.fatLabel.text = [nutrientString stringByAppendingString:@" g"];
    
    value = (count * mass * [self.carbValue doubleValue])/100;
    nutrientString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    self.carbLabel.text = [nutrientString stringByAppendingString:@" g"];

    value = (count * mass * [self.calorieValue doubleValue])/100;
    nutrientString = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    self.caloriesLabel.text = nutrientString;
}

-(void)addFood
{
    NSString *url = [BaseURLString stringByAppendingString:@"addFood"];
    
    NSDictionary* parameters = @{
                                 @"logDate" : logDate,
                                 @"mealTypeID" : mealTypeID,
                                 @"foodID" : foodID,
                                 @"portionID" : portionID,
                                 @"portionCount" : portionCount.text,
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

-(void)updateFood
{
    NSString *url = [BaseURLString stringByAppendingString:@"updateFood"];
    
    NSDictionary* parameters = @{
                                 @"action" : @"edit",
                                 @"recordID" : recordID,
                                 @"portionID" : portionID,
                                 @"portionCount" : portionCount.text,
                                 @"confirm" : @"Y",
                                 @"token" : [[DataModel sharedInstance] userToken]
                                 };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFXMLDictionaryResponseSerializer serializer];
    
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation* operation, id responseObject) {
             [self.navigationController popViewControllerAnimated:YES];
         }
         failure:^(AFHTTPRequestOperation* operation, NSError* error) {
         }];
    
}

-(void)deleteFood
{
    NSString *url = [BaseURLString stringByAppendingString:@"updateFood"];
    
    NSDictionary* parameters = @{
                                 @"action" : @"delete",
                                 @"recordID" : recordID,
                                 @"token" : [[DataModel sharedInstance] userToken]
                                 };
    
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFXMLDictionaryResponseSerializer serializer];
    
    [manager GET:url
      parameters:parameters
         success:^(AFHTTPRequestOperation* operation, id responseObject) {
             [self.navigationController popViewControllerAnimated:YES];
         }
         failure:^(AFHTTPRequestOperation* operation, NSError* error) {
         }];
    
}
@end
