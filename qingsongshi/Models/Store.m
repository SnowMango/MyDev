//
//  Store.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "Store.h"

@implementation Store


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.devices = [NSMutableArray new];
    }
    return self;
}

@end
