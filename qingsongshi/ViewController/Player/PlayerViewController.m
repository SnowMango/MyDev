//
//  PlayerViewController.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "PlayerViewController.h"
#import "Store.h"


@interface PlayerViewController ()

@property(strong, nonatomic) UCloudMediaPlayer *mediaPlayer;

@property (weak, nonatomic) IBOutlet UIView *playView;
@property (assign, nonatomic) CGFloat current;
@end

@implementation PlayerViewController
- (void)dealloc
{
    [self removePlayerNotificaton];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self play];
    [self addPlayerNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChangeNoti:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)addPlayerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:UCloudPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:UCloudPlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:UCloudMoviePlayerSeekCompleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:UCloudPlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:UCloudPlayerPlaybackDidFinishNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:UCloudPlayerBufferingUpdateNotification object:nil];

}

- (void)removePlayerNotificaton
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlaybackIsPreparedToPlayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudMoviePlayerSeekCompleted object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerPlaybackDidFinishNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UCloudPlayerBufferingUpdateNotification object:nil];
}

- (void)deviceOrientationDidChangeNoti:(id)notification
{
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
    //重绘画面
    self.mediaPlayer.player.view.frame = self.playView.bounds;
    [self.mediaPlayer refreshView];
    
}

- (void)onNotification:(NSNotification *)noti
{
    if ([noti.name isEqualToString:UCloudPlaybackIsPreparedToPlayDidChangeNotification])
    {
       
        if (self.current != 0)
        {
            [self.mediaPlayer.player setCurrentPlaybackTime:self.current];
            self.current = 0;
        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerLoadStateDidChangeNotification])
    {
        if ([self.mediaPlayer.player loadState] == MPMovieLoadStateStalled)
        {
            //网速不好，开始缓冲
        }
        else if ([self.mediaPlayer.player loadState] == (MPMovieLoadStatePlayable|MPMovieLoadStatePlaythroughOK))
        {
            //缓冲完毕
        }
    }
    else if ([noti.name isEqualToString:UCloudMoviePlayerSeekCompleted])
    {
        
    }
    else if ([noti.name isEqualToString:UCloudPlayerPlaybackStateDidChangeNotification])
    {
        NSLog(@"backState:%ld", (long)[self.mediaPlayer.player playbackState]);
//        if (!self.isPrepared)
//        {
//            self.isPrepared = YES;
//            [self.mediaPlayer.player play];
//            
//            if (![self.mediaPlayer.player isPlaying])
//            {
//                [self.controlVC refreshCenterState];
//            }
//        }
    }
    else if ([noti.name isEqualToString:UCloudPlayerPlaybackDidFinishNotification])
    {
        MPMovieFinishReason reson = [[noti.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        
        SubErrorCode subErrorCode = [[noti.userInfo objectForKey:@"error"] integerValue];
        
        if (reson == MPMovieFinishReasonPlaybackEnded)
        {
            
        }
        else if (reson == MPMovieFinishReasonPlaybackError)
        {
            NSLog(@"player manager finish reason playback error! subErrorCode:%@",@(subErrorCode));
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"视频播放错误" delegate:self cancelButtonTitle:@"知道了"   otherButtonTitles: nil, nil];
            alert.tag = 103;
            [alert show];
        }
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self colsePlayer];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)colsePlayer
{
    [self.mediaPlayer.player.view removeFromSuperview];
    [self.mediaPlayer.player shutdown];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UCloudMoviePlayerClickBack object:self];
}

- (IBAction)play
{
    //    隐藏导航栏
//    [self setNeedsStatusBarAppearanceUpdate];
    
    NSString *str = self.device.sn;
    
    if (str.length == 0)
    {
        out:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意" message:@"URL不可用" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *theMovieURL =[NSURL URLWithString:str];
    
    if (theMovieURL == nil)
    {
        goto out;
    }
    
    if ([theMovieURL isFileURL])
    {
        NSLog(@"is file url");
    }
    
    if ([theMovieURL checkResourceIsReachableAndReturnError:nil])
    {
        NSLog(@"error");
    }
    
    
    [self configPlayer];
}


- (void)configPlayer
{
    self.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
    
    NSString *path = self.device.sn;
    if ([path.pathExtension hasSuffix:@"m3u8"]) {
        //HLS如果对累积延时没要求，建议把setDelayOptimization设置为NO，这样播放过程中卡顿率会更低
        [self.mediaPlayer setDelayOptimization:YES];
        [self.mediaPlayer setCachedDuration:5000];
        [self.mediaPlayer setBufferDuration:3000];
    }
    else {
        [self.mediaPlayer setDelayOptimization:YES];
        [self.mediaPlayer setCachedDuration:2000];
        [self.mediaPlayer setBufferDuration:2000];
    }
    __weak typeof(self) weakSelf = self;
    float width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    CGRect rect = {{0,0},{width, width*9/16}};
    [self.mediaPlayer showMediaPlayer:path urltype:UrlTypeLive frame:rect view:self.playView completion:^(NSInteger defaultNum, NSArray *data) {
        if (self.mediaPlayer) {
            weakSelf.mediaPlayer.player.scalingMode = MPMovieScalingModeAspectFit;
//            [[NSNotificationCenter defaultCenter] postNotificationName:UCloudPlayerVideoChangeRotationNotification object:@(0)];
        }
    }];

}

#pragma mark - 截图
- (void)shotscreen
{
    UIImage *image = [self.mediaPlayer.player thumbnailImageAtCurrentTime];
    
    NSLog(@"shotscreen %@", image? @"成功":@"失败");
//    [self saveImageToPhotos:image];
}
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - 解码方式
- (void)selectedDecodeMethod:(DecodeMethod)decodeMethod
{
    self.current = [self.mediaPlayer.player currentPlaybackTime];
    [self.mediaPlayer selectDecodeMethod:decodeMethod];
    [self.mediaPlayer.player setCurrentPlaybackTime:self.current];
}
#pragma mark - 清晰度
- (void)selectedDefinition:(Definition)definition
{
    self.current = [self.mediaPlayer.player currentPlaybackTime];
    [self.mediaPlayer selectDefinition:definition];
    [self.mediaPlayer.player setCurrentPlaybackTime:self.current];
}

#pragma mark - 设置音量
- (void)playerVolume:(float)volume
{
    [MPMusicPlayerController applicationMusicPlayer].volume = volume;
}



@end

