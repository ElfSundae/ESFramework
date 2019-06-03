//
//  NSError+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSError+ESExtension.h"

@implementation NSError (ESExtension)

+ (instancetype)errorWithDomain:(NSErrorDomain)domain
                           code:(NSInteger)code
                    description:(NSString *)description
{
    return [self errorWithDomain:domain code:code description:description failureReason:nil];
}

+ (instancetype)errorWithDomain:(NSErrorDomain)domain
                           code:(NSInteger)code
                    description:(NSString *)description
                  failureReason:(NSString *)failureReason
{
    NSMutableDictionary *userInfo = nil;
    if (description || failureReason) {
        userInfo = [NSMutableDictionary dictionary];
        if (description) {
            userInfo[NSLocalizedDescriptionKey] = description;
        }
        if (failureReason) {
            userInfo[NSLocalizedFailureReasonErrorKey] = failureReason;
        }
    }
    return [self errorWithDomain:domain code:code userInfo:userInfo];
}

@end
