//
//  DetailViewController.m
//  SnapCalories
//
//  Created by Sindu on 11/18/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "ExerciseDetailViewController.h"

@interface ExerciseDetailViewController ()

@end

@implementation ExerciseDetailViewController

@synthesize exerciseDesc, exerciseTypeID, levelDict, exerciseID, logDate;

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
    levelDict = [[NSMutableDictionary alloc]init];
    
    [self getExerciseDetails];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getExerciseDetails
{
    NSString *urlStr = [NSString stringWithFormat:@"https://www.nutrihand.com/Nutrihand/servlet/getExerciseDetails?id=%@&token=%@", exerciseID, [[DataModel sharedInstance] userToken]];
    
    
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
        if ([levelDict count] > 0)
        {
            [levelDict removeAllObjects];
        }
    }
    else if ([elementName isEqualToString:@"exerciseDetails"])
    {
        exerciseTypeID = [attributeDict objectForKey:@"exerciseTypeID"];
        exerciseDesc = [attributeDict objectForKey:@"desc"];
    }
    else if ([elementName isEqualToString:@"detail"])
    {
        levelDict[[attributeDict objectForKey:@"levelDesc"]] = [attributeDict objectForKey:@"levelId"];
    }
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count = 0;
  
    return count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
 
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

- (void) pickerDoneClicked
{
}

@end
