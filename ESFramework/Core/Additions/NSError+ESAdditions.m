//
//  NSError+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSError+ESAdditions.h"

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

- (BOOL)isLocalNetworkError
{
        return ([self.domain isEqualToString:NSURLErrorDomain] &&
                (NSURLErrorTimedOut == self.code ||
                 NSURLErrorCannotFindHost == self.code ||
                 NSURLErrorCannotConnectToHost == self.code ||
                 NSURLErrorNetworkConnectionLost == self.code ||
                 NSURLErrorDNSLookupFailed == self.code ||
                 NSURLErrorNotConnectedToInternet == self.code));
}

@end
