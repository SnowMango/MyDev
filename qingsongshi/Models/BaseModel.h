//
//  BaseModel.h
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCopying, NSMutableCopying>

@end


static inline NSDictionary * BaseModelDictionaryProprety(id obj);
