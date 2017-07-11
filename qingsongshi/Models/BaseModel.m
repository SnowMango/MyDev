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


#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone
{
    id newObj = [[self class] allocWithZone:zone];
    NSArray *properties = [self objc_properties];
    NSDictionary *propertyDic = [self dictionaryWithValuesForKeys:properties];
    [newObj setValuesForKeysWithDictionary:propertyDic];
    return newObj;
}
#pragma mark - NSMutableCoping
-(id)mutableCopyWithZone:(NSZone *)zone
{
    id newObj = [[self class] allocWithZone:zone];
    NSArray *properties = [self objc_properties];
    for (NSString *key in properties) {
        id value = [self valueForKey:key];
        if ([value conformsToProtocol:@protocol(NSMutableCopying)]) {
            value = [value mutableCopy];
        }
        [newObj setValue:value forKey:key];
    }
    return newObj;
}

- (NSArray *)objc_properties
{
    NSMutableArray *properties=[NSMutableArray new];
    unsigned int propertyCount = 0;
    objc_property_t * propertList = class_copyPropertyList( [self class], &propertyCount);
    for ( NSUInteger i = 0; i < propertyCount; i++ ){
        const char * name = property_getName(propertList[i]);
        NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [properties addObject:propertyName];
    }
    free(propertList);
    return properties;
}

@end

@implementation NSObject (PropretyValue)

- (NSDictionary *)propretyValue
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList( [self class], &propertyCount );
    
    for ( NSUInteger i = 0; i < propertyCount; i++ )
    {
        const char * name = property_getName(properties[i]);
        NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:propertyName];
        if (value) {
            dic[propertyName] = value;
        }
    }
    free(properties);
    return dic;
}

@end


NSDictionary * propretyValueWithObj(id obj)
{
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList( [obj class], &propertyCount );
    
    for ( NSUInteger i = 0; i < propertyCount; i++ )
    {
        const char * name = property_getName(properties[i]);
        NSString * propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        NSObject *value = [obj valueForKey:propertyName];
        if (value) {
            dic[propertyName] = value;
        }
    }
    free(properties);
    return dic;
}




