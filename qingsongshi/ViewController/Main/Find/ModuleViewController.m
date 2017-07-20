//
//  ModuleViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/5.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//


@interface ModuleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ModuleCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#import "ModuleViewController.h"
@interface ModuleViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * modules;
@end

@implementation ModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.layer.cornerRadius
    self.modules =[self urls];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(collectionView.frame)-15*2 -10)/2.0;
    CGFloat height = width*9/16.0+20;
    return CGSizeMake(width, height);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.modules.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ModuleCellID" forIndexPath:indexPath];
    NSString *urlStr = self.modules[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLabel.text = @(indexPath.row+1).stringValue;
    return cell;
}

- (NSArray *)urls
{
    return @[@"http://e.hiphotos.baidu.com/zhidao/pic/item/d62a6059252dd42a24457129023b5bb5c8eab8e7.jpg",
             @"http://pic3.zhongsou.com/image/3805136b09be936d79b.jpg",
             @"http://d.hiphotos.baidu.com/zhidao/pic/item/10dfa9ec8a13632789e9c937938fa0ec08fac7aa.jpg",
             @"http://t1.niutuku.com/960/25/25-320250.jpg",
             @"http://t-1.tuzhan.com/442ffee5b0c9/c-1/l/2012/08/29/06/d44b642f8f604b0984e6a3fd8e43782b.jpg",
             @"http://image.it168.com/n/640x480/5/5304/5304272.jpg",
             @"http://farm5.staticflickr.com/4109/4995447265_fb490674a5.jpg",
             @"http://k.zol-img.com.cn/dcbbs/20960/a20959415_01000.jpg",];
}


@end
