//
//  IModule.h
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/5.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IULCModule <NSObject>

@property (assign, nonatomic) NSString * moduleName;
@property (assign, nonatomic) UIImage * moduleIcon;

@end

@interface IModule : NSObject<IULCModule>

@property (assign, nonatomic) NSString * moduleName;
@property (assign, nonatomic) UIImage * moduleIcon;

@end
