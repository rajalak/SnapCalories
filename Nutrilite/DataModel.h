//
//  Datamodel.h
//  fmdb1
//
//  Created by Sys Admin on 4/16/14.
//  Copyright (c) 2014 General Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import <FMDB/FMResultSet.h>

@interface DataModel : NSObject

@property(nonatomic, strong) FMDatabaseQueue *databaseQueue;
@property(nonatomic, copy) NSString *pushNotification;
@property(nonatomic, copy) NSString *userToken;

+(instancetype)sharedInstance;

-(void)executeStatement:(void (^)(FMDatabase *db))block;

@end
