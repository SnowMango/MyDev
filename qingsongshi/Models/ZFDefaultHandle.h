//
//  ZFDefaultHandle.h
//  qingsongshi
//
//  Created by zhengfeng on 2017/7/18.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZFDefaultHandle : NSObject

+(ZFDefaultHandle*)shareInstance;


- (NSArray*)handleStore;

@end

