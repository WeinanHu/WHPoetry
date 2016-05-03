//
//  WNPoetryKind.h
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WNPoetryKind : NSObject
@property(nonatomic,strong) NSString *poetryKindName;
@property(nonatomic,assign) long poetryKindID;
@property(nonatomic,strong) NSString *poetryKindDesc;
@property(nonatomic,strong) NSString *poetryKindComment;

//两个接口
//返回所有的诗词分类的数组（TRPoetryKind）
+(NSArray*)kinds;
//给定诗词分类的名字，返回删除是否成功
+(BOOL)removeWithKind:(NSString*)kindName;

@end
