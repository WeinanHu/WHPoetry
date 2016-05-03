//
//  WNPoetryKind.m
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WNPoetryKind.h"
#import "WNDatabaseManager.h"

@implementation WNPoetryKind
+(BOOL)removeWithKind:(NSString*)kindName{
    FMDatabase *database = [WNDatabaseManager sharedDatabase];
    BOOL isSuccess = [database executeUpdateWithFormat:@"delete from T_KIND where D_KIND = %@",kindName];
    [database close];
    return isSuccess;
}

+(NSArray*)kinds{
    FMDatabase *database = [WNDatabaseManager sharedDatabase];
    FMResultSet *result = [database executeQueryWithFormat:@"select * from T_KIND"];
    NSMutableArray *kinds = [NSMutableArray array];
    while ([result next]) {
        WNPoetryKind *poetryKind = [WNPoetryKind new];
        poetryKind.poetryKindName = [result stringForColumn:@"D_KIND"];
        poetryKind.poetryKindID = [result longForColumn:@"D_NUM"];
        poetryKind.poetryKindComment = [result stringForColumn:@"D_INTROKIND2"];
        poetryKind.poetryKindDesc = [result stringForColumn:@"D_INTROKIND"];
        [kinds addObject:poetryKind];
    }
    [database close];
    return [kinds copy];
}
@end
