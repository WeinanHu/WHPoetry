//
//  WNDatabaseManager.m
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WNDatabaseManager.h"

@implementation WNDatabaseManager
+(FMDatabase *)sharedDatabase{
    static FMDatabase *database;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"Poetry.bundle" ofType:nil];
        NSString *dbFilePath = [bundlePath stringByAppendingPathComponent:@"sqlite.db"];
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *targetFilePath = [documentPath stringByAppendingPathComponent:@"sqlite.db"];
        NSError *error;
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:targetFilePath]) {
            [[NSFileManager defaultManager]copyItemAtPath:dbFilePath toPath:targetFilePath error:&error];
        }
        if(!error){
            //没有错误
            database = [FMDatabase databaseWithPath:targetFilePath];
        }
    });
    [database open];
    return database;
}
@end
