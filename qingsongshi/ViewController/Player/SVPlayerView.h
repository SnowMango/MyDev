//
//  SVPlayerView.h
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/18.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLPlayerKit.h"


@protocol SVPlayerViewDelegate <PLPlayerDelegate>

@end

@class Store, Device;
@interface SVPlayerView : UIView<PLPlayerDelegate>
@property (nonatomic, strong) PLPlayer  *player;

@property (weak, nonatomic) id <SVPlayerViewDelegate> delegate;
@property (copy, nonatomic) Device * device;


- (void)play;

- (void)stop;

- (void)getScreenShotWithCompletionHandler:(ScreenShotWithCompletionHandler)handle;


@end
