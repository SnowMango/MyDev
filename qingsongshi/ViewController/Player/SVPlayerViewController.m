//
//  SVPlayerViewController.m
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/19.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "SVPlayerViewController.h"
#import "SVPlayerView.h"

@import SocketIO;

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

@property (nonatomic, getter=isPlayerPlay) BOOL playerPlay;

@end

@implementation SVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.playerView.delegate = self;

    self.currentPlayDeviceIndex = self.defaultIndex;
    [self playDevice];
    self.playerPlay = YES;

}

- (void)socketIOTest
{
    NSURL* url = [[NSURL alloc] initWithString:@"http://localhost:8080"];
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
    [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
        double cur = [[data objectAtIndex:0] floatValue];
        
        [[socket emitWithAck:@"canUpdate" with:@[@(cur)]] timingOutAfter:0 callback:^(NSArray* data) {
            [socket emit:@"update" with:@[@{@"amount": @(cur + 2.50)}]];
        }];
        
        [ack with:@[@"Got your currentAmount, ", @"dude"]];
    }];
    
    [socket connect];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.playerPlay = NO;
    [self.playerView stop];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)playDevice
{
    Device *d = self.playStore.devices[self.currentPlayDeviceIndex];
    self.playerView.device = d;

    [self.playerView play];
}

- (void)setPlayerPlay:(BOOL)playerPlay
{
    _playerPlay = playerPlay;
    NSString *imageName = _playerPlay ? @"player_stop":@"player_playing";
    [self.playBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


- (IBAction)playAndStopClick:(UIButton *)sender {
    self.playerPlay = !self.isPlayerPlay;
    if (self.isPlayerPlay) {
        [self.playerView play];
    }else{
        [self.playerView stop];
    }
}

- (IBAction)screenShotClick:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    [SVProgressHUD showInfoWithStatus:@"正在截图..."];
    [self.playerView getScreenShotWithCompletionHandler:^(UIImage * _Nullable image) {
        [SVProgressHUD showInfoWithStatus:@"截图成功..."];
        [SVProgressHUD dismissWithDelay:0.5];
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
    [collectionView reloadData];
}



@end
