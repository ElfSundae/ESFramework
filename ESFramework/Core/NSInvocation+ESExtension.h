//
//  NSInvocation+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/23.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInvocation (ESExtension)

+ (nullable instancetype)invocationWithTarget:(id)target selector:(SEL)selector, ...;
+ (nullable instancetype)invocationWithTarget:(id)target selector:(SEL)selector arguments:(va_list)arguments;

@end

NS_ASSUME_NONNULL_END
