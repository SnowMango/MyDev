//
//  SVPlayerView.m
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/18.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "SVPlayerView.h"
#import "Store.h"


static NSString *status[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusCaching",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError"
};

@interface SVPlayerView ()


@property (nonatomic, assign) int reconnectCount;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end


@implementation SVPlayerView


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
    [self setupPlayer];
    
}


-(void)setupUI
{
    self.backgroundColor = [UIColor blackColor];
    
    self.activityIndicatorView.hidden = YES;
}

- (void)setupPlayer
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    self.player = [PLPlayer playerWithURL:nil option:option];
    self.player.delegate = self;
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.backgroundPlayEnable = YES;

    [self addSubview:self.player.playerView];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.player) {
        self.player.playerView.frame = self.bounds;
    }
    [self sendSubviewToBack:self.player.playerView];
}


- (void)play
{
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];

    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.player playWithURL:[NSURL URLWithString:self.device.sn]];
}

- (void)stop
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if (self.player.isPlaying) {
       [self.player stop];
    }
}

- (void)getScreenShotWithCompletionHandler:(ScreenShotWithCompletionHandler)handle
{
    [self.player getScreenShotWithCompletionHandler:handle];
}


#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (PLPlayerStatusCaching == state) {
        self.activityIndicatorView.hidden = NO;
        [self.activityIndicatorView startAnimating];
    } else if (PLPlayerStatusPlaying == state){
        [self.activityIndicatorView stopAnimating];
        self.activityIndicatorView.hidden = YES;
    }
    NSLog(@"%@", status[state]);
    if ([self.delegate respondsToSelector:@selector(player: statusDidChange:)]) {
        [self.delegate player:player statusDidChange:state];
    }
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
    
    if ([self.delegate respondsToSelector:@selector(player: stoppedWithError:)]) {
        [self.delegate player:player stoppedWithError:error];
    }
}

@end
