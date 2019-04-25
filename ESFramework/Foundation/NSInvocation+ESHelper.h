//
//  NSInvocation+ESHelper.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSInvocation (ESHelper)

+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector;
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments, ...;
+ (instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments arguments:(va_list)arguments;

- (void)es_getReturnValue:(void *)returnValue;

@end