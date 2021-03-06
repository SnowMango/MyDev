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
#import "SVPlayerViewController.h"

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

@property (nonatomic, copy) void (^selectDeivce)(Device * device);

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
    [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:d.iconURL] placeholderImage:[UIImage imageNamed:@""]];
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 115;
    CGFloat height = CGRectGetHeight(collectionView.frame);
    return CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDelegate
-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Device * d = self.deviceList[indexPath.row];
    
    if (self.selectDeivce) {
        self.selectDeivce(d);
    }
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
    
    self.tableView.rowHeight = 115;
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
    __weak typeof(self)weakSelf = self;
    cell.selectDeivce = ^(Device *d)
    {
        SVPlayerViewController *vc = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateInitialViewController];
        vc.playStore = s;
        vc.defaultIndex = [s.devices indexOfObject:d];
        [weakSelf.navigationController showViewController:vc sender:nil];
    };
    [cell loadData];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Store *s = self.dataList[indexPath.row];
    SVPlayerViewController *vc = [[UIStoryboard storyboardWithName:@"Player" bundle:nil] instantiateInitialViewController];
    vc.playStore = s;
    [self.navigationController showViewController:vc sender:nil];
}



@end
