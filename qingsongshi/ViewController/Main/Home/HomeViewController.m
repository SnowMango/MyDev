//
//  HomeViewController.m
//  qingsongshi
//
//  Created by 郑丰 on OFFSET_CHANGE17/1/5.
//  Copyright © OFFSET_CHANGE17年 zhengfeng. All rights reserved.
//

#import "HomeViewController.h"
#import <AVKit/AVKit.h>
#import "Store.h"   

@interface HomeSubCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@end

@implementation HomeSubCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}
@end


@interface HomeCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *titleLb;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *deviceList;

- (void)loadData;

@end

@implementation HomeCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)loadData
{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.deviceList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeSubCellId" forIndexPath:indexPath];
    
    Device * d = self.deviceList[indexPath.row];
    
    cell.nameLb.text = d.name;
    
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 100;
    CGFloat height = CGRectGetHeight(collectionView.frame);
    return CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDelegate
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *storeNumLb;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumLb;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSArray *dataList;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataList = [[ZFDefaultHandle shareInstance] handleStore];
    
    self.tableView.rowHeight = 131;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell*cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCellId" forIndexPath:indexPath];
    
    Store*s = self.dataList[indexPath.row];
    
    cell.titleLb.text =  s.name;
    
    cell.deviceList = s.devices;
    
    [cell loadData];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
