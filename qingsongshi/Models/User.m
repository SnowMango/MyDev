//
//  User.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "User.h"

@implementation User
+ (instancetype)defaultUser
{
    User *u = [[User alloc] init];
    u.nickname = @"初体验";
    u.account = @"admin";
    u.identifier = @"123456";
    u.password = @"123";
    u.iconURL = @"http://mvimg2.meitudata.com/56df9b5c4fcc86529.jpg";
    
    u.roleName = @"管理员";
    u.roleIdentifier = @"100";
    return u;
}
@end
