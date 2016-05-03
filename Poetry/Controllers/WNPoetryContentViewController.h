//
//  WNPoetryContentViewController.h
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WNPoetry.h"
@interface WNPoetryContentViewController : UIViewController
-(instancetype)initWithPoetry:(WNPoetry*)poetry;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,assign) BOOL isLoading;
@end
