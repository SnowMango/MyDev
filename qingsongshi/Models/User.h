//
//  User.h
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel

@property (strong, nonatomic) NSString * nickname;
@property (strong, nonatomic) NSString * account;
@property (strong, nonatomic) NSString * identifier;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) NSString * iconURL;

@property (strong, nonatomic) NSString * roleName;
@property (strong, nonatomic) NSString * roleIdentifier;

+ (instancetype)defaultUser;
@end
