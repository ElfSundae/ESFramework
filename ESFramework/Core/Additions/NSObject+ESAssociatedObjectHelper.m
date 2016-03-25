//
//  NSObject+ESAssociatedObjectHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 15/9/4.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "NSObject+ESAssociatedObjectHelper.h"

@implementation NSObject (ESAssociatedObjectHelper)

- (BOOL)es_getAssociatedBooleanWithKey:(const void *)key defaultValue:(BOOL)defaultValue
{
        return ESBoolValueWithDefault(ESGetAssociatedObject(self, key), defaultValue);
}

- (void)es_setAssociatedBooleanWithKey:(const void *)key value:(BOOL)value
{
        ESSetAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)es_getAssociatedIntegerWithKey:(const void *)key defaultValue:(NSInteger)defaultValue
{
        return ESIntegerValueWithDefault(ESGetAssociatedObject(self, key), defaultValue);
}

- (void)es_setAssociatedIntegerWithKey:(const void *)key value:(NSInteger)value
{
        ESSetAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)es_getAssociatedUIntegerWithKey:(const void *)key defaultValue:(NSUInteger)defaultValue
{
        return ESUIntegerValueWithDefault(ESGetAssociatedObject(self, key), defaultValue);
}

- (void)es_setAssociatedUIntegerWithKey:(const void *)key value:(NSUInteger)value
{
        ESSetAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (double)es_getAssociatedDoubleWithKey:(const void *)key defaultValue:(double)defaultValue
{
        return ESDoubleValueWithDefault(ESGetAssociatedObject(self, key), defaultValue);
}

- (void)es_setAssociatedDoubleWithKey:(const void *)key value:(double)value
{
        ESSetAssociatedObject(self, key, @(value), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)es_getAssociatedStringWithKey:(const void *)key defaultValue:(NSString *)defaultValue
{
        return ESStringValueWithDefault(ESGetAssociatedObject(self, key), defaultValue);
}

- (void)es_setAssociatedStringWithKey:(const void *)key value:(NSString *)value
{
        ESSetAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSURL *)es_getAssociatedURLWithKey:(const void *)key defaultValue:(NSURL *)defaultValue
{
        return ESURLValueWithDefault(ESGetAssociatedObject(self, key), defaultValue);
}

- (void)es_setAssociatedURLWithKey:(const void *)key value:(NSURL *)value
{
        ESSetAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)es_getAssociatedWeakObjectWithKey:(const void *)key defaultValue:(id)defaultValue
{
        ESWeak(defaultValue);
        return ESGetAssociatedObject(self, key) ?: weak_defaultValue;
}

- (void)es_setAssociatedWeakObjectWithKey:(const void *)key value:(id)value
{
        ESWeak(value);
        ESSetAssociatedObject(self, key, weak_value, OBJC_ASSOCIATION_WEAK);
}

@end
