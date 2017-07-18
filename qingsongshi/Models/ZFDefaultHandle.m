//
//  ZFDefaultHandle.m
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/18.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "ZFDefaultHandle.h"
#import "Store.h"
@implementation ZFDefaultHandle
+(ZFDefaultHandle*)shareInstance
{
    static ZFDefaultHandle *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[ZFDefaultHandle alloc] init];
    });
    return handle;
}



- (NSArray*)handleStore
{
    NSMutableArray* dataList = [NSMutableArray array];
    for (int i = 1; i<=10; i++) {
        Store * s = [[Store alloc] init];
        s.name = @(i).stringValue;
        for (int j =1; j <=5; j++) {
            Device *d = [[Device alloc] init];
            d.name = @(j).stringValue;
            d.sn = @"222";
            d.store = s;
            [s.devices addObject:d];
        }
        [dataList addObject:s];
    }

    return dataList;
}


@end
