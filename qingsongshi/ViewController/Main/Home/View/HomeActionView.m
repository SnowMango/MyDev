///Users/zhengfeng/Desktop/MyDev/qingsongshi/ViewController
//  HomeActionView.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/7.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "HomeActionView.h"

@implementation HomeActionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageView.userInteractionEnabled = YES;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    [self addGestureRecognizer:tap];
}

- (void)addTarget:(id)target seletor:(SEL)sel
{
    [tap addTarget:target action:sel];
}

- (void)selfTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"tap");
}


@end
