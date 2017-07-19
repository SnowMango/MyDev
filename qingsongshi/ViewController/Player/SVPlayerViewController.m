//
//  SVPlayerViewController.m
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/19.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "SVPlayerViewController.h"
#import "SVPlayerView.h"

@interface PlayDeviceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView * iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;

@end

@implementation PlayDeviceCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

@end

@interface SVPlayerViewController ()<SVPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet SVPlayerView *playerView;
@property (weak, nonatomic) IBOutlet UIView *playerToolView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *screenShotBtn;

@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *playbackBtn;

@property (nonatomic) NSInteger currentPlayDeviceIndex;

@end

@implementation SVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.delegate = self;
    
//    [self playDevice];
}
- (void)playDevice
{
    Device *d = self.playStore.devices[self.currentPlayDeviceIndex];
    self.playerView.device = d;
    [self.playerView play];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (IBAction)playAndStopClick:(UIButton *)sender {
    
    NSString *imageName = self.playerView.player.isPlaying ? @"player_stop":@"player_playing";
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (IBAction)screenShotClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    [self.playerView getScreenShotWithCompletionHandler:^(UIImage * _Nullable image) {
        sender.userInteractionEnabled = YES;
    }];
}

#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    
    
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    NSString *imageName =@"player_playing";
    [self.playBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.playStore.devices.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayDeviceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayDeviceCellId" forIndexPath:indexPath];
    Device *d = self.playStore.devices[indexPath.row];
    cell.nameLb.text = d.name;
    cell.layer.borderColor = [UIColor yellowColor].CGColor;
    cell.layer.borderWidth = self.currentPlayDeviceIndex == indexPath.row?1:0;
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
    if (self.currentPlayDeviceIndex == indexPath.row) {
        return;
    }
    self.currentPlayDeviceIndex = indexPath.row;
    Device *d = self.playStore.devices[indexPath.row];
    self.playerView.device = d;
    [self.playerView play];
}



@end
