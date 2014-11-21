//
//  MealSummaryViewController.m
//  SnapCalories
//
//  Created by Sindu on 9/22/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "MealSummaryViewController.h"
#import "FoodLog.h"
#import "FoodDetailViewController.h"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/servlet/";
@interface MealSummaryViewController ()

@end

@implementation MealSummaryViewController

@synthesize  sectionArray, dataDict, mealTypeDict, counter, isMealType, mealSummaryView, datePicker, dateFormatter, datePickerView;
@synthesize logDate, foodID, foodName, portionCount, portionDesc, mealTypeID, recordID, calories;

NSTimeInterval dayInSeconds = 24 * 60 * 60;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getMealSummary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sectionArray = [[NSMutableArray alloc]init];
    dataDict = [[NSMutableDictionary alloc]init];
    mealTypeDict = [[NSMutableDictionary alloc]init];
    mealTypeDict[@"1"] = @"Breakfast";
    mealTypeDict[@"2"] = @"Snack1";
    mealTypeDict[@"3"] = @"Lunch";
    mealTypeDict[@"4"] = @"Snack2";
    mealTypeDict[@"5"] = @"Dinner";
    mealTypeDict[@"6"] = @"Snack3";
    
}

- (NSDateFormatter *)formatter
{
    if (! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    return dateFormatter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showDatePicker:(id)sender
{
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,180,320,300)];
    datePickerView.backgroundColor = [UIColor grayColor];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake( 120, 6, 100, 30 );
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(dueDateChanged:) forControlEvents:UIControlEventTouchUpInside];
    
    datePicker = [[UIDatePicker alloc] init];
    datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
    datePicker.frame = CGRectMake(0.0, 50, pickerSize.width, 260);
    
    [datePickerView addSubview:button];
    [datePickerView addSubview:datePicker];
    
    [self.view addSubview:datePickerView];
}

-(void) dueDateChanged:(UIDatePicker *)sender {
    
    logDate =  [[self formatter] stringFromDate:[datePicker date]];
    [datePickerView removeFromSuperview];
    [self getMealSummary];
}

- (IBAction)prevButtonClicked:(id)sender
{
    NSDate *date = [[self formatter] dateFromString:self.logDate];
    date = [date dateByAddingTimeInterval:-dayInSeconds];
    logDate = [[self formatter] stringFromDate:date];
    [self getMealSummary];
}

- (IBAction)nextButtonClicked:(id)sender
{
    NSDate *date = [[self formatter] dateFromString:self.logDate];
    date = [date dateByAddingTimeInterval:dayInSeconds];
    logDate = [[self formatter] stringFromDate:date];
    [self getMealSummary];
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

-(void)getMealSummary
{
    self.navigationItem.title = self.logDate;
    
    
    NSString *urlStr = [NSString stringWithFormat:@"https://www.nutrihand.com/Nutrihand/servlet/getMealSummary?token=%@&logDate=%@",[[DataModel sharedInstance] userToken],logDate];
    
    
	NSURL *url = [NSURL URLWithString:urlStr];
	
    
    NSString *str = [[NSString alloc]initWithContentsOfURL:url];
	str = [str stringByReplacingOccurrencesOfString:@"Æ" withString:@"®"];
    
    BOOL success = NO;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    [parser setDelegate:self];
	[parser setShouldProcessNamespaces:NO];
	[parser setShouldReportNamespacePrefixes:NO];
	[parser setShouldResolveExternalEntities:NO];
    success = [parser parse];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"Response"])
    {
        if ([sectionArray count] > 0)
        {
            [sectionArray removeAllObjects];
            [dataDict removeAllObjects];
            counter = 0;
        }
    }
    else if([elementName isEqualToString:@"mealTypeID"])
    {
        isMealType = YES;
    }
    else if([elementName isEqualToString:@"food"])
    {
        foodID = [attributeDict objectForKey:@"foodID"];
        portionDesc = [attributeDict objectForKey:@"portion"];
        portionCount = [attributeDict objectForKey:@"portionCount"];
        recordID = [attributeDict objectForKey:@"recordID"];
        calories = [attributeDict objectForKey:@"calories"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error %@", [parseError description]);
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [mealSummaryView reloadData];
    
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isMealType)
    {
        NSString* str = string;
        self.mealTypeID  = str;
        isMealType = NO;
        sectionArray[counter] = str;
        counter = counter + 1;
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *foodDesc = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    FoodLog *foodLog = [[FoodLog alloc]initWithValues:self.foodID withPortionDesc:self.portionDesc withPortionCount:self.portionCount withMealTypeID:self.mealTypeID withRecordID:self.recordID withCalories:self.calories withFoodName:foodDesc];
    
    NSMutableArray *foodLogArray;
    int cntr = 0;
    if ((foodLogArray = [dataDict objectForKey:self.mealTypeID]) != nil)
    {
        cntr = [foodLogArray count];
    }
    else
    {
        foodLogArray = [[NSMutableArray alloc]init];
    }
    foodLogArray[cntr] = foodLog;
    dataDict[self.mealTypeID] = foodLogArray;
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* mealTypeIndex =  [sectionArray objectAtIndex:section];
    return [mealTypeDict objectForKey:mealTypeIndex];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* mealTypeIndex = [sectionArray objectAtIndex:section];
    NSMutableArray* foodLogArray = [dataDict objectForKey:mealTypeIndex];
    return [foodLogArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *mealTypeIndex = [sectionArray objectAtIndex:indexPath.section];
    NSMutableArray *foodLogArray = [dataDict objectForKey:mealTypeIndex];
    FoodLog *foodLog = [foodLogArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [foodLog foodName];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    header.contentView.backgroundColor = [UIColor purpleColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *mealTypeIndex = [sectionArray objectAtIndex:indexPath.section];
    NSMutableArray *foodLogArray = [dataDict objectForKey:mealTypeIndex];
    FoodLog *foodLog = [foodLogArray objectAtIndex:indexPath.row];
    if (logDate == nil)
    {
        NSDate *today = [NSDate date];
        logDate = [[self formatter] stringFromDate:today];
    }
    
    UIStoryboard* storyboard = self.storyboard;
    
    FoodDetailViewController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@ "FoodDetailViewController"];
    detailVC.title = @"Details";
    detailVC.foodID = [foodLog foodID];
    detailVC.foodName = [foodLog foodName];
    detailVC.logDate = [self logDate];
    detailVC.editPortionCount = [foodLog portionCount];
    detailVC.editPortionDesc = [foodLog portionDesc];
    detailVC.mealTypeID = [foodLog mealTypeID];
    detailVC.recordID = [foodLog recordID];
    detailVC.userAction = @"edit";
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
