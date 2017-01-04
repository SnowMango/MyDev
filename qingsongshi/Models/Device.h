//
//  Device.h
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "BaseModel.h"


@class Store;
@interface Device : BaseModel

@property (weak, nonatomic) Store * store;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * identifier;
@property (strong, nonatomic) NSString * sn;
@end
