//
//  WNMainCollectionViewController.m
//  Poetry
//
//  Created by tarena on 16/4/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WNMainCollectionViewController.h"
#import "WNCollectionViewCell.h"
#import "WNPoetry.h"
#import "WNPoetryKind.h"
#import "WNPoetryListTableViewController.h"
#import "WNPoetryContentViewController.h"

@interface WNMainCollectionViewController ()<UICollectionViewDelegateFlowLayout,PoetryKindCellDelegate>
@property(nonatomic,strong) NSArray *poetryArray;
@property(nonatomic,strong) NSArray *poetryKindArray;
@property(nonatomic,assign) BOOL isEditing;
@property(nonatomic,strong) UIFont *font;
@end

@implementation WNMainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
-(NSArray *)poetryArray{
    if (_poetryArray==nil) {
        
        _poetryArray = [WNPoetry poetryListWithKind:@"五言古诗"];
    }
    return _poetryArray;
}
-(NSArray *)poetryKindArray{
    if (_poetryKindArray==nil) {
        _poetryKindArray = [WNPoetryKind kinds];
    }
    return _poetryKindArray;
}
-(void)clickEditItem{
    if (!self.isEditing) {
        self.isEditing = YES;
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else{
        self.isEditing = NO;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
    [self.collectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    WNPoetryContentViewController *pltvc = [[WNPoetryContentViewController alloc]init];
    pltvc.isLoading = YES;
    [self.navigationController pushViewController:pltvc animated:NO];
    
    
    self.font = [UIFont fontWithName:@"Li Xuke" size:40];
    
    
    
   
    
    self.isEditing = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(clickEditItem)];
    self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.poetryKindArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.deleteButton.hidden = self.isEditing?NO:YES;
    WNPoetryKind *poetryKind = self.poetryKindArray[indexPath.row];
    NSLog(@"%@",poetryKind.poetryKindName);
    [cell loadImageWithString:poetryKind.poetryKindName
     ];
    return cell;
}

//PoetryKindCellDelegate
-(void)removePoetryKindCell:(WNCollectionViewCell *)poetryKindCell{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:poetryKindCell];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除诗词分类" message:@"确定永久删除该诗词分类吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        WNPoetryKind *poetryKind = self.poetryKindArray[indexPath.row];
        if ([WNPoetryKind removeWithKind:poetryKind.poetryKindName]) {
            NSLog(@"成功删除数据库中的poetryKind");
            self.poetryKindArray = nil;
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
//            [self.collectionView reloadData];
        }
        
    }];
    [alert addAction:actionCancel];
    [alert addAction:actionDone];
    [self presentViewController:alert animated:YES completion:nil];
    
}
//设置cell/item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //原图片大小：340X160
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 15) / 2-20;
    CGFloat height = 160 * width / 340;
    
    return CGSizeMake(width, height);
}
//设置cell的行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.0;
}
#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isEditing) {
        return;
    }
    WNPoetryKind *poetryKind = self.poetryKindArray[indexPath.row];
    WNPoetryListTableViewController *tvc = [[WNPoetryListTableViewController alloc]initWithKindName:poetryKind.poetryKindName];
    tvc.font =self.font;
    [self.navigationController pushViewController:tvc animated:YES];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
