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

@end
