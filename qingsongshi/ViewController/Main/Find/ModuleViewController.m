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
    
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ModuleCellID" forIndexPath:indexPath];
    
    cell.titleLabel.text = @(indexPath.row+1).stringValue;
    return cell;
}


@end
