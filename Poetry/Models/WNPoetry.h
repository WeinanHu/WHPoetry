//
//  WNPoetry.h
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WNPoetry : NSObject
@property(nonatomic,strong) NSString *poetryContent;
@property(nonatomic,strong) NSString *poetryComment;
@property(nonatomic,strong) NSString *poetryAuthor;
@property(nonatomic,strong) NSString *poetryKind;
@property(nonatomic,assign) long poetryID;
@property(nonatomic,strong) NSString *poetryTitle;
+(NSArray*)poetryListWithKind:(NSString*)kindName;
+(BOOL)removePoetryWithID:(long)poetryID;
@end
