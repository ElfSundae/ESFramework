//
//  NSObject+ESAssociatedObjectHelper.h
//  ESFramework
//
//  Created by Elf Sundae on 15/9/4.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"
#import "ESValue.h"

/*!
 * The helper additions for NSObject which allows you to easily get or set the associated objects
 * in a Class Category.
 */
@interface NSObject (ESAssociatedObjectHelper)

- (BOOL)es_getAssociatedBooleanWithKey:(const void *)key defaultValue:(BOOL)defaultValue;
/// @note the association policy is OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)es_setAssociatedBooleanWithKey:(const void *)key value:(BOOL)value;

- (NSInteger)es_getAssociatedIntegerWithKey:(const void *)key defaultValue:(NSInteger)defaultValue;
/// @note the association policy is OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)es_setAssociatedIntegerWithKey:(const void *)key value:(NSInteger)value;

- (NSUInteger)es_getAssociatedUIntegerWithKey:(const void *)key defaultValue:(NSUInteger)defaultValue;
/// @note the association policy is OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)es_setAssociatedUIntegerWithKey:(const void *)key value:(NSUInteger)value;

- (double)es_getAssociatedDoubleWithKey:(const void *)key defaultValue:(double)defaultValue;
/// @note the association policy is OBJC_ASSOCIATION_RETAIN_NONATOMIC
- (void)es_setAssociatedDoubleWithKey:(const void *)key value:(double)value;

- (NSString *)es_getAssociatedStringWithKey:(const void *)key defaultValue:(NSString *)defaultValue;
/// @note the association policy is OBJC_ASSOCIATION_COPY_NONATOMIC
- (void)es_setAssociatedStringWithKey:(const void *)key value:(NSString *)value;

- (NSURL *)es_getAssociatedURLWithKey:(const void *)key defaultValue:(NSURL *)defaultValue;
/// @note the association policy is OBJC_ASSOCIATION_COPY_NONATOMIC
- (void)es_setAssociatedURLWithKey:(const void *)key value:(NSURL *)value;

- (id)es_getAssociatedWeakObjectWithKey:(const void *)key defaultValue:(id)defaultValue;
/// @note the association policy is OBJC_ASSOCIATION_WEAK
- (void)es_setAssociatedWeakObjectWithKey:(const void *)key value:(id)value;

@end
