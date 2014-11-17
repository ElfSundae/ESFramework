//
//  NSError+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ESAdditions)

/// Set the `description` to NSLocalizedDescriptionKey of userInfo.
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

/// Set the NSLocalizedDescriptionKey and the NSLocalizedFailureReasonErrorKey of userInfo.
+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description failureReason:(NSString *)failureReason;

@end
