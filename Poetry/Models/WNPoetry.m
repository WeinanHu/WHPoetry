//
//  WNPoetry.m
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WNPoetry.h"
#import "FMDB.h"
#import "WNDatabaseManager.h"
@implementation WNPoetry
+(BOOL)removePoetryWithID:(long)poetryID{
    FMDatabase *database = [WNDatabaseManager sharedDatabase];
    BOOL isSuccess = [database executeUpdateWithFormat:@"delete from T_SHI where D_KIND = %ld",poetryID];
    [database close];
    return isSuccess;
}
+(NSArray*)poetryListWithKind:(NSString*)kindName{
    //1、database对象
    FMDatabase *database = [WNDatabaseManager sharedDatabase];

    //2、执行有条件的查询语句
    FMResultSet *result = [database executeQueryWithFormat:@"select * from T_SHI where D_KIND = %@",kindName];
    
    //3、循环转换；存到数组
    NSMutableArray *poetries = [NSMutableArray new];
    while ([result next]) {
        WNPoetry *poetry = [WNPoetry new];
        poetry.poetryContent = [result stringForColumn:@"D_SHI"];
        poetry.poetryComment = [result stringForColumn:@"D_INTROSHI"];
        poetry.poetryAuthor = [result stringForColumn:@"D_AUTHOR"];
        poetry.poetryKind = [result stringForColumn:@"D_KIND"];
        poetry.poetryID = [result longForColumn:@"D_ID"];
        poetry.poetryTitle = [result stringForColumn:@"D_TITLE"];
        [poetries addObject:poetry];
    }
    //4、返回数组
    [database close];
    return [poetries copy];
}


@end
