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
             @"http://image.it168.com/n/640x480/5/5304/5304272.jpg",
             
             @"http://farm5.staticflickr.com/4109/4995447265_fb490674a5.jpg",
             @"http://k.zol-img.com.cn/dcbbs/20960/a20959415_01000.jpg",
             @"https://img3.doubanio.com/view/photo/lphoto/public/p2260182646.jpg",
             @"http://pic.qiantucdn.com/58pic/17/96/02/55b47f6726bbd_1024.jpg!/fw/780/watermark/url/L3dhdGVybWFyay12MS4zLnBuZw==/align/center",
             @"http://img165.poco.cn/mypoco/myphoto/20110916/08/64330850201109160847583045587592300_004.jpg",
             
             @"http://d.hiphotos.baidu.com/zhidao/pic/item/cdbf6c81800a19d8d7698e0131fa828ba61e464f.jpg",
             @"http://b.hiphotos.baidu.com/zhidao/pic/item/c2fdfc039245d68875a5adeea7c27d1ed31b24d0.jpg",
             @"http://img2.niutuku.com/desk/1208/1524/ntk-1524-42504.jpg",
             @"http://file28.mafengwo.net/M00/D9/CB/wKgB6lPwFjiANXY6AAiE0hb3v-A79.jpeg",
             @"http://img2.niutuku.com/desk/1208/1043/bizhi-1043-1392.jpg",
             
             @"http://image1.caixin.cn/2011-09-16/201109160073_840_560.jpg",
             @"http://s15.sinaimg.cn/middle/a2c9c13bhca367302a90e&690",
             @"http://img2.niutuku.com/desk/1207/0836/ntk60315.jpg",
             @"http://file31.mafengwo.net/M00/DE/A0/wKgBs1goj3yAVU8BACr-HCLvEbk61.jpeg",
             @"http://img.article.pchome.net/00/44/23/20/pic_lib/wm/6.jpg"
             ];
}


@end
