//
//  WNCollectionViewCell.m
//  Poetry
//
//  Created by tarena on 16/4/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WNCollectionViewCell.h"
@interface WNCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation WNCollectionViewCell
-(void)loadImageWithString:(NSString*)string{
    self.backgroundImageView.image = [UIImage imageNamed:string];
}
- (IBAction)clickDeleteButton:(UIButton*)sender {
    if (!self.deleteButton.hidden) {
        if ([self.delegate respondsToSelector:@selector(removePoetryKindCell:)]) {
            [self.delegate removePoetryKindCell:self];
        }
    }
    
}

@end
