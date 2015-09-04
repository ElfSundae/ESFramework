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
 * //TODO: add others types
 */
@interface NSObject (ESAssociatedObjectHelper)

- (BOOL)es_getAssociatedBooleanWithKey:(const void *)key defaultValue:(BOOL)defaultValue;
- (void)es_setAssociatedBooleanWithKey:(const void *)key value:(BOOL)value;

@end
