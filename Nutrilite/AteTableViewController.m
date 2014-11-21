//
//  IAteViewControllerTableViewController.m
//  SnapCalories
//
//  Created by Sys Admin on 5/10/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "AteTableViewController.h"
#import "AteTableViewCell.h"
#import "UIImage+Utilities.h"
#import "AteDetailViewController.h"
#import "AtePickerViewController.h"

#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"

static NSString* const BaseURLString = @"https://www.nutrihand.com/Nutrihand/saveFoodLogImage.do";

@interface AteTableViewController () <DBCameraViewControllerDelegate>

@end

@implementation AteTableViewController

@synthesize dataset;
@synthesize selectedIndexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl* refreshControl = [[UIRefreshControl alloc] init];

    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Pull to Refresh", nil)];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

    self.refreshControl = refreshControl;

    UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 44)];

    UIButton* left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(20, 10, 24, 24);
    [left setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

    [barView addSubview:left];

    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 320, 44)];
    [title setText:@"Today"];

    [barView addSubview:title];

    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(150, 10, 24, 24);
    [right setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];

    [barView addSubview:right];

    [self.navigationItem setTitleView:barView];

    [self refreshDataset];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveCalories:)
                                                 name:@"pushNotificationArrive" object:nil];

}

#pragma mark - Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataset.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"AteCellIdentifier";

    AteTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    NSDictionary* record = [dataset objectAtIndex:indexPath.row];

    cell.foodMealType.text = record[@"mealType"];

    if ([record[@"mealCalories"] integerValue]>0) {
        cell.foodCalories.text = [NSString stringWithFormat:@"%@ %@", record[@"mealCalories"], NSLocalizedString(@"Cal", nil)];
    }
    else {
        cell.foodCalories.text = NSLocalizedString(@"Analyzing", nil);
    }
    
    NSData* photo = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@thumbnail", record[@"mealImage"]]]];

    [cell.imageView setImage:[UIImage imageWithData:photo]];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    AteDetailViewController* detail = [[AteDetailViewController alloc]
        initWithNibName:@"AteDetailViewController"
                 bundle:nil];

    detail.dataSource = self;
    detail.delegate = self;
    selectedIndexPath = indexPath;

    [detail setCurrentPreviewItemIndex:indexPath.row];

    [self.navigationController pushViewController:detail animated:YES];
}

- (id<QLPreviewItem>)previewController:(QLPreviewController*)controller previewItemAtIndex:(NSInteger)index
{
    NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary* record = [dataset objectAtIndex:indexPath.row];
    NSString* filePath = record[@"mealImage"];
    return [NSURL URLWithString:filePath];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController*)controller
{
    return 1;
}

#pragma mark - Take Photo

- (void)mealTypeButton:(id)sender
{
    UIButton* button = (UIButton*)sender;

    [button setTitle:@"Dinner" forState:UIControlStateNormal];
}

- (IBAction)takePhoto:(id)sender
{
    UIImagePickerController *container = [[UIImagePickerController alloc] init];
    container.sourceType=UIImagePickerControllerSourceTypeCamera;
    container.delegate=self;
    container.editing=YES;
    
    [self presentViewController:container animated:YES completion:nil];

}


- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    UIImage* image = info[UIImagePickerControllerEditedImage];

    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }

    NSString* userToken = [[DataModel sharedInstance] userToken];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy-hh-mm-ss"];

    NSString* mealDateTime = [NSString stringWithFormat:@"%@",
                                                        [formatter stringFromDate:[NSDate date]]];

    NSArray* arrayMeal = [mealDateTime componentsSeparatedByString:@"-"];

    NSString* mealDate = [NSString stringWithFormat:@"%@-%@-%@", arrayMeal[0], arrayMeal[1], arrayMeal[2]];

    NSString* mealTime = [NSString stringWithFormat:@"%@-%@", arrayMeal[3], arrayMeal[4]];

    NSString* userFoodImageName = [NSString stringWithFormat:@"%@.%@-%@", userToken, mealDate, mealTime];
    
    NSString* mealID = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                                  arrayMeal[0],
                                                  arrayMeal[1],
                                                  arrayMeal[2],
                                                  arrayMeal[3],
                                                  arrayMeal[4],
                                                  arrayMeal[5]];

    NSString* fileName = [NSString stringWithFormat:@"%@.jpg",
                                                    mealID];

    NSURL* url = [[[[NSFileManager defaultManager]
        URLsForDirectory:NSDocumentDirectory
               inDomains:NSUserDomainMask] firstObject]
        URLByAppendingPathComponent:fileName];

    NSString* filePath = [NSString stringWithFormat:@"%@", url];

    NSData* data = UIImageJPEGRepresentation(image, 0.7);

    //thumbnail

    [data writeToURL:url atomically:YES];

    UIImage* thumbnail = [UIImage imageWithImage:[UIImage imageWithData:data] scaledToFillSize:CGSizeMake(45, 45)];

    NSData* thumbnailData = UIImageJPEGRepresentation(thumbnail, 1);

    NSURL* urlThumbnail = [[[[NSFileManager defaultManager]
        URLsForDirectory:NSDocumentDirectory
               inDomains:NSUserDomainMask] firstObject]
        URLByAppendingPathComponent:[NSString stringWithFormat:@"%@thumbnail", fileName]];

    [thumbnailData writeToURL:urlThumbnail atomically:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[DataModel sharedInstance] executeStatement:^(FMDatabase *db) {
            [db executeUpdate:@"INSERT INTO MealLog VALUES (?,?,?,?,?,?,?)",
                mealID,
                filePath,
                @"Breakfast",
                @"",
                mealDate,
             userToken,
             userFoodImageName
             ];
            
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshDataset];
        });
    }];
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSDictionary *parameters = @{@"type"        : @"foodLog",
                                     @"logDate"     : mealDate,
                                     @"logTime"     : mealTime,
                                     @"mealTypeID"  : @"5",
                                     @"token"       : [[DataModel sharedInstance] userToken]
                                     };
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        
        [manager POST:BaseURLString
           parameters:parameters
            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:url name:@"myimage" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    });

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh:(UIRefreshControl*)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refresh..."];

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@" MMM d, h:mm a"];
    NSString* lastUpdated = [NSString stringWithFormat:@"Last update on %@", [formatter stringFromDate:[NSDate date]]];

    [self reloadCalories];

    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void)refreshDataset
{
    __block NSMutableArray* result = [NSMutableArray array];

    [[DataModel sharedInstance] executeStatement:^(FMDatabase* db) {
        
        FMResultSet *resultSet = [db executeQuery:@"select * from MealLog order by rowid desc;"];
        
        while ([resultSet next]) {
            NSDictionary *dictionary = [resultSet resultDictionary];
            [result addObject:[dictionary copy]];
        }
        [resultSet close];
    }];

    dataset = [result mutableCopy];

    [self.tableView reloadData];
}

-(void)receiveCalories:(NSNotification*)info
{
    [self reloadCalories];
}

- (void)reloadCalories
{
    NSString* url = @"https://www.nutrihand.com/Nutrihand/servlet/getMealSummary";

    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString* mealDateTime = [NSString stringWithFormat:@"%@",
                              [formatter stringFromDate:[NSDate date]]];
    
    NSLog(@"date: %@, %@", mealDateTime, [[DataModel sharedInstance] userToken]);
    
    NSDictionary* parameters = @{
        @"logDate" : mealDateTime,
        @"token" : [[DataModel sharedInstance] userToken]
    };

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFXMLDictionaryResponseSerializer serializer];

    [manager GET:url
        parameters:parameters
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            
            NSDictionary* data = [responseObject copy];
            
            NSDictionary* dictionary = [data objectForKey:@"mealTypeID"];
            
            NSArray* array = [dictionary objectForKey:@"food"];
            
            for (id item in array)
            {
                NSString* userFoodImageName = [item valueForKeyPath:@"_userFoodImageName"];
                NSString* calories = [item valueForKeyPath:@"_calories"];
                
                NSLog(@"username: %@", userFoodImageName);

                [self updateCalories:userFoodImageName andCalories:calories];
            }
            
            [self refreshDataset];
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            [self refreshDataset];
        }];
}

- (void)updateCalories:(NSString*)userFoodImageName andCalories:(NSString*)calories
{
    NSString* image =userFoodImageName;
    NSString* cal = calories;
    
    [[DataModel sharedInstance] executeStatement:^(FMDatabase* db) {
        
        [db executeUpdate:@"update mealLog set mealCalories = ? where userFoodImageName = ? ", cal, image];
        
    }];
    
}


@end
