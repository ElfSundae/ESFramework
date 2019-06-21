//
//  NSError+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (ESExtension)

/**
 * Creates and initializes an NSError object for a given domain and code with a
 * given localized description.
 */
+ (instancetype)errorWithDomain:(NSErrorDomain)domain
                           code:(NSInteger)code
                    description:(nullable NSString *)description;

/**
 * Creates and initializes an NSError object for a given domain and code with a
 * given localized description and a given localized failure reason.
 */
+ (instancetype)errorWithDomain:(NSErrorDomain)domain
                           code:(NSInteger)code
                    description:(nullable NSString *)description
                  failureReason:(nullable NSString *)failureReason;

@end

NS_ASSUME_NONNULL_END
