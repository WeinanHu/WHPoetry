//
//  WNCollectionViewCell.h
//  Poetry
//
//  Created by tarena on 16/4/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WNCollectionViewCell;

@protocol PoetryKindCellDelegate <NSObject>
-(void)removePoetryKindCell:(WNCollectionViewCell*)poetryKindCell;
@end
@interface WNCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

-(void)loadImageWithString:(NSString*)string;
@property(nonatomic,weak) id<PoetryKindCellDelegate>delegate;
@end
