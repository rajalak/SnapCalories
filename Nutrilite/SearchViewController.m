//
//  SearchViewController.m
//  SnapCalories
//
//  Created by Sindu on 9/8/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "SearchViewController.h"
#import "FoodDetailViewController.h"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/servlet/";


@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize foodResultsView, foodSearchBar, dataArray, dataDict, searchText, page, nextPage, prevButton, nextButton, foodID, counter, datePickerView, datePicker, suggestArray;
@synthesize foodName, logDate, dateFormatter, favPortionCount, favPortionID, favPortionCountDict, favPortionIDDict;



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
    dataArray = [[NSMutableArray alloc]init];
    dataDict = [[NSMutableDictionary alloc]init];
    favPortionIDDict = [[NSMutableDictionary alloc]init];
    favPortionCountDict = [[NSMutableDictionary alloc]init];
    suggestArray = [[NSMutableArray alloc]init];
    self.prevButton.hidden = YES;
    self.nextButton.hidden = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getFavoriteFoods];
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

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"search text %@", searchBar.text);
    self.prevButton.hidden = YES;
    self.nextButton.hidden = YES;
    [searchBar resignFirstResponder];
    searchText = searchBar.text;
    page = [NSNumber numberWithInt:0];
    [self populateTableView];
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

- (IBAction)nextButtonClicked:(id)sender
{
    page = nextPage;
    [self populateTableView];
}

- (IBAction)prevButtonClicked:(id)sender
{
    int value = [page intValue];
    if (value != 0)
        value = value - 1;
    page = [NSNumber numberWithInt:value];
    [self populateTableView];
}

-(IBAction)showDatePicker:(id)sender
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

- (IBAction)favoriteButtonClicked:(id)sender
{
    self.prevButton.hidden = YES;
    self.nextButton.hidden = YES;
    self.nextPage = 0;
    [favPortionCountDict removeAllObjects];
    [favPortionIDDict removeAllObjects];
    [self getFavoriteFoods];
}

- (IBAction)customButtonClicked:(id)sender
{
    self.prevButton.hidden = YES;
    self.nextButton.hidden = YES;
    self.nextPage = 0;
    [self getCustomFoods];
}


-(void) dueDateChanged:(UIDatePicker *)sender {
    
    logDate =  [[self formatter] stringFromDate:[datePicker date]];
    [datePickerView removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *suggestStr = [alertView buttonTitleAtIndex:buttonIndex];
    if (![suggestStr  isEqual: @"None"])
    {
        searchText = suggestStr;
        page = [NSNumber numberWithInt:0];
        [self populateTableView];
    }
}

- (void) populateTableView
{
    NSString *urlStr = [NSString stringWithFormat:@"https://www.nutrihand.com/Nutrihand/servlet/searchFood?text=%@&page=%@&version=3&ios=true",searchText,[NSString stringWithFormat:@"%@",page]];
    
    urlStr = [[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
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
    
    if ([elementName isEqualToString:@"Root"])
    {
        if ([dataArray count] > 0)
        {
            [dataArray removeAllObjects];
            [dataDict removeAllObjects];
            counter = 0;
        }
        if ([suggestArray count] > 0)
            [suggestArray removeAllObjects];
    }
    else if([elementName isEqualToString:@"params"])
    {
        NSNumber *value = [attributeDict objectForKey:@"next"];
        if (value != nil)
            nextPage = value;
        else
            nextPage = page;
    }
    else if([elementName isEqualToString:@"food"])
    {
        foodID = [attributeDict objectForKey:@"id"];
        if ([attributeDict objectForKey:@"portionCount"] != nil)
        {
            favPortionCount = [attributeDict objectForKey:@"portionCount"];
            favPortionCountDict[foodID] = favPortionCount;
        }
        if ([attributeDict objectForKey:@"portionID"] != nil)
        {
            favPortionID = [attributeDict objectForKey:@"portionID"];
            favPortionIDDict[foodID] = favPortionID;
        }
    }
    else if ([elementName isEqualToString:@"suggestion"])
    {
        int suggestCount = [suggestArray count];
        suggestArray[suggestCount] = [attributeDict objectForKey:@"value"];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"food"])
    {
        counter = counter + 1;
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error %@", [parseError description]);
              
}
          
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (([dataArray count] > 0) && ([nextPage intValue] > 0))
    {
        self.prevButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
    if ([dataArray count] > 0)
        [foodResultsView reloadData];
    else
    {
        if ([suggestArray count] > 0)
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Results found."
                                                          message:@"Did you mean?"
                                                         delegate:self
                                                cancelButtonTitle:@"None"
                                                    otherButtonTitles:[suggestArray objectAtIndex:0], [suggestArray objectAtIndex:1], [suggestArray objectAtIndex:2], nil];
            [message show];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *foodDesc = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    dataArray[counter] = foodDesc;
    dataDict[foodDesc] = foodID;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    // Set the data for this cell:
    
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"More text";
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    
    // set the accessory view:
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *localFoodName = [[cell textLabel] text];
    NSString *localFoodID = [dataDict objectForKey:localFoodName];
    
    if (logDate == nil)
    {
        NSDate *today = [NSDate date];
        logDate = [[self formatter] stringFromDate:today];
    }
    
    UIStoryboard* storyboard = self.storyboard;
    
    FoodDetailViewController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@ "FoodDetailViewController"];
    detailVC.title = @"Details";
    detailVC.foodID = localFoodID;
    detailVC.foodName = localFoodName;
    detailVC.logDate = logDate;
    detailVC.editPortionID = [favPortionIDDict objectForKey:localFoodID];
    detailVC.editPortionCount = [favPortionCountDict objectForKey:localFoodID];
    detailVC.userAction = @"add";
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)getFavoriteFoods
{
    NSString *urlStr = [NSString stringWithFormat:@"https://www.nutrihand.com/Nutrihand/servlet/getFavoriteFoodsIphone?token=%@",[[DataModel sharedInstance] userToken]];
    
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

-(void)getCustomFoods
{
    NSString *urlStr = [NSString stringWithFormat:@"https://www.nutrihand.com/Nutrihand/servlet/getCustomFoodsRecipes?token=%@",[[DataModel sharedInstance] userToken]];
    
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
@end
