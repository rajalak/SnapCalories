//
//  ExerciseSearchViewController.m
//  SnapCalories
//
//  Created by Sindu on 11/18/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "ExerciseSearchViewController.h"

static NSString * const BaseURLString = @"https://www.nutrihand.com/Nutrihand/servlet/";
@interface ExerciseSearchViewController ()

@end

@implementation ExerciseSearchViewController

@synthesize exerciseSearchBar, exerciseTableView, dataArray, dataDict, searchText, logDate, dateFormatter;

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
    dataDict = [[NSMutableDictionary alloc]init];
    dataArray = [[NSMutableArray alloc]init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)formatter
{
    if (! dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yyyy";
    }
    return dateFormatter;
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchText = searchBar.text;
    [self populateTableView];
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
    NSString *localExerciseName = [[cell textLabel] text];
    NSString *localExerciseID = [dataDict objectForKey:localExerciseName];
    
    if (logDate == nil)
    {
        NSDate *today = [NSDate date];
        logDate = [[self formatter] stringFromDate:today];
    }
    
    UIStoryboard* storyboard = self.storyboard;
    
    /*FoodDetailViewController* detailVC = [storyboard instantiateViewControllerWithIdentifier:@ "FoodDetailViewController"];
    detailVC.title = @"Details";
    detailVC.foodID = localFoodID;
    detailVC.foodName = localFoodName;
    detailVC.logDate = logDate;
    detailVC.editPortionID = [favPortionIDDict objectForKey:localFoodID];
    detailVC.editPortionCount = [favPortionCountDict objectForKey:localFoodID];
    detailVC.userAction = @"add";
    
    [self.navigationController pushViewController:detailVC animated:YES];*/
}

- (void) populateTableView
{
    NSString *urlStr = [NSString stringWithFormat:@"https://www.nutrihand.com/Nutrihand/servlet/searchExercise?text=%@&ios=true",searchText];
    
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
    
    if ([elementName isEqualToString:@"Response"])
    {
        if ([dataArray count] > 0)
        {
            [dataArray removeAllObjects];
            [dataDict removeAllObjects];
        }
    }
    else if([elementName isEqualToString:@"exercise"])
    {
        NSString *name = [attributeDict objectForKey:@"name"];
        dataArray[[dataArray count]] = name;
        dataDict[name] = [attributeDict objectForKey:@"id"];
    }
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error %@", [parseError description]);
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([dataArray count] > 0)
        [exerciseTableView reloadData];
}


@end
