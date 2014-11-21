//
//  Datamodel.m
//  fmdb1
//
//  Created by Sys Admin on 4/16/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize databaseQueue;
@synthesize pushNotification;
@synthesize userToken;

+(instancetype)sharedInstance {
    static DataModel *datamodel;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        datamodel = [[DataModel alloc] init];
    });
    
    return datamodel;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *databaseName = @"database.sqlite";
    NSString *documentPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                   NSUserDomainMask, YES)
                               lastObject]
                              stringByAppendingPathComponent:databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        NSError *error = nil;
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        
        if (![[NSFileManager defaultManager] copyItemAtPath:bundlePath toPath:documentPath error:&error]) {
            NSLog(@"%@,%s", error, __func__);
        }
    }
    databaseQueue = [FMDatabaseQueue databaseQueueWithPath:documentPath];
    
    return self;
}

-(void)executeStatement:(void (^)(FMDatabase *db))block
{
    [databaseQueue inDatabase:^(FMDatabase *db) {
        block(db);
    }];
}

@end
