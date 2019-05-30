//
//  NSInvocation+ESHelper.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (ESHelper)

+ (nullable instancetype)invocationWithTarget:(id)target selector:(SEL)selector;
+ (nullable instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments, ...;
+ (nullable instancetype)invocationWithTarget:(id)target selector:(SEL)selector retainArguments:(BOOL)retainArguments arguments:(va_list)arguments;

@end

NS_ASSUME_NONNULL_END
