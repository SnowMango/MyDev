//
//  BaseModel.m
//  qingsongshi
//
//  Created by 郑丰 on 2017/1/4.
//  Copyright © 2017年 zhengfeng. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[self class] allocWithZone:zone];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList( [self class], &propertyCount );
    for ( NSUInteger i = 0; i < propertyCount; i++ )
    {
        const char * name = property_getName(properties[i]);
        NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSObject<NSCopying> * tempValue = [self valueForKey:propertyName];
        if (tempValue) {
            id value = [tempValue copy];
            [copy setValue:value forKey:propertyName];
        }
    }
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    id mutableCopy = [[self class] allocWithZone:zone];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList( [self class], &propertyCount );
    for ( NSUInteger i = 0; i < propertyCount; i++ )
    {
        const char * name = property_getName(properties[i]);
        NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSObject<NSCopying> * tempValue = [self valueForKey:propertyName];
        if (tempValue) {
            id value = [tempValue mutableCopy];
            [mutableCopy setValue:value forKey:propertyName];
        }
    }
    return mutableCopy;
}

@end
