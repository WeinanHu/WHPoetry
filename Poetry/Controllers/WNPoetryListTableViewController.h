//
//  WNPoetryListTableViewController.h
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WNPoetryListTableViewController : UITableViewController
-(instancetype)initWithKindName:(NSString*)kindName;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,assign) BOOL isLoading;
@end
