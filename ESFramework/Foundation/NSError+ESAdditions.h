//
//  NSError+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (ESAdditions)

+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code description:(nullable NSString *)description;
+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code description:(nullable NSString *)description failureReason:(nullable NSString *)failureReason;

@end

NS_ASSUME_NONNULL_END
