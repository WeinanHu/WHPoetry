//
//  WNDatabaseManager.h
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface WNDatabaseManager : NSObject
//返回一个已经创建好的数据库对象
+(FMDatabase*)sharedDatabase;



@end
