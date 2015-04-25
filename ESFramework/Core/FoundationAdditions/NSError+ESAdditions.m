//
//  NSError+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSError+ESAdditions.h"
#import "ESDefines.h"

ES_CATEGORY_FIX(NSError_ESAdditions)

@implementation NSError (ESAdditions)

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description
{
        NSDictionary *userInfo = nil;
        if ([description isKindOfClass:[NSString class]]) {
                userInfo = @{ NSLocalizedDescriptionKey: description };
        }
        return [self errorWithDomain:domain code:code userInfo:userInfo];
}

+ (instancetype)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description failureReason:(NSString *)failureReason
{
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        if ([description isKindOfClass:[NSString class]]) {
                userInfo[NSLocalizedDescriptionKey] = description;
        }
        if ([failureReason isKindOfClass:[NSString class]]) {
                userInfo[NSLocalizedFailureReasonErrorKey] = failureReason;
        }
        NSDictionary *info = (userInfo.count) ? (NSDictionary *)userInfo : nil;
        return [self errorWithDomain:domain code:code userInfo:info];
}

@end