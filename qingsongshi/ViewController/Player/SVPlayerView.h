//
//  SVPlayerView.h
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/18.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLPlayerKit.h"

@interface SVPlayerView : UIView<PLPlayerDelegate>
@property (nonatomic, strong) PLPlayer  *player;


@end
