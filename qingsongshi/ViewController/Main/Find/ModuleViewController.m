//
//  ModuleViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/5.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//


@interface ModuleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ModuleCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#import "ModuleViewController.h"
#import "IModule.h"
@interface ModuleViewController ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray * modules;
@end

@implementation ModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *fileName = [NSString stringWithFormat:@"%@/ModuleConfig.plist",[NSBundle mainBundle].bundlePath];
    NSArray *moduleArray = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *module in moduleArray) {
        IModule *m = [[IModule alloc] init];
        m.moduleName = module[@"name"];
        [temp addObject:m];
    }
    self.modules = temp;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 3)/3.0;
    return CGSizeMake(width, width);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 0);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ModuleReusableID" forIndexPath:indexPath];
        reusableview = footerview;
    }
    return reusableview;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return ceil(self.modules.count/3.0);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    if(kAPPBoundleType == 1){
    //        if (section==2) {
    //            return 2;
    //        }
    //        return 3;
    //    }
    if (++section*3 > self.modules.count) {
        return self.modules.count%3;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ModuleCellID" forIndexPath:indexPath];
    NSInteger index = indexPath.section*3+indexPath.row;
    if (index < self.modules.count) {
        id<IULCModule>module = self.modules[index];
//        cell.imageView.image = [module moduleIcon];
        cell.titleLabel.text = [module moduleName];
    }else{
        cell.imageView.image = nil;
        cell.titleLabel.text = nil;
    }
    return cell;
}


@end
