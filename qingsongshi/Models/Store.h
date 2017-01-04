//
//  Store.h
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "BaseModel.h"
#import "Device.h"
@interface Store : BaseModel
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * identifier;
@property (strong, nonatomic) NSArray <Device *>* devices;
@end
