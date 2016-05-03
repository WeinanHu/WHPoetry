//
//  WNPoetryListTableViewController.m
//  Poetry
//
//  Created by tarena on 16/4/15.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "WNPoetryListTableViewController.h"
#import "WNPoetry.h"
#import "WNPoetryTableViewCell.h"
#import "WNPoetryContentViewController.h"
@interface WNPoetryListTableViewController ()
@property(nonatomic,strong) NSMutableArray *poetryList;
@property(nonatomic,strong) NSString *kindName;
@end

@implementation WNPoetryListTableViewController
-(NSMutableArray *)poetryList{
    if (_poetryList== nil) {
        _poetryList = [[WNPoetry poetryListWithKind:self.kindName]mutableCopy];
    }
    return _poetryList;
}
-(instancetype)initWithKindName:(NSString*)kindName{
    if (self = [super init]) {
        self.kindName = kindName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    if (self.isLoading) {
//        self.isLoading = NO;
//        [self.navigationController popViewControllerAnimated:NO];
//    }
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景"]];
//    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.poetryList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WNPoetryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (!cell) {
        cell = [[WNPoetryTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"tableCell"];
    }
    WNPoetry *poetry = self.poetryList[indexPath.row];
    cell.textLabel.text = poetry.poetryTitle;
    
    cell.detailTextLabel.text = poetry.poetryAuthor;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSIndexPath *indexPathDelete = [NSIndexPath indexPathForItem:indexPath.row inSection:0];
        if(indexPathDelete ==nil){
            return;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除诗词分类" message:@"确定永久删除该诗词分类吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            WNPoetry *poetry = self.poetryList[indexPathDelete.row];
            if ([WNPoetry removePoetryWithID:poetry.poetryID]) {
                NSLog(@"成功删除%ld号诗",poetry.poetryID);
                [self.poetryList removeObjectAtIndex:indexPathDelete.row];
                [tableView deleteRowsAtIndexPaths:@[indexPathDelete] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
        [alert addAction:actionCancel];
        [alert addAction:actionDone];
        [self presentViewController:alert animated:YES completion:nil];

        
        
//        self.poetryList = nil;
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除此诗";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WNPoetry *poetry = self.poetryList[indexPath.row];
    WNPoetryContentViewController *pcvc = [[WNPoetryContentViewController alloc]initWithPoetry:poetry];
    pcvc.font =self.font;

    [self.navigationController pushViewController:pcvc animated:YES];
}
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
