//
//  UIDevice+ESNetworkReachability.m
//  ESFramework
//
//  Created by Elf Sundae on 4/22/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "UIDevice+ESNetworkReachability.h"

@implementation UIDevice (ESNetworkReachability)

+ (void)load
{
        @autoreleasepool {
                [[self sharedNetworkReachabilityForInternetConnection] startNotifier];
        }
}

+ (ESNetworkReachability *)sharedNetworkReachabilityForInternetConnection
{
        static ESNetworkReachability *__sharedNetworkReachabilityForInternetConnection = nil;
        if (nil == __sharedNetworkReachabilityForInternetConnection) {
                __sharedNetworkReachabilityForInternetConnection = [ESNetworkReachability reachabilityForInternetConnection];
        }
        return __sharedNetworkReachabilityForInternetConnection;
}

+ (ESNetworkReachabilityStatus)currentNetworkReachabilityStatus
{
        return [self sharedNetworkReachabilityForInternetConnection].currentReachabilityStatus;
}

+ (NSString *)currentNetworkReachabilityStatusString
{
        return ESNetworkReachabilityStatusString([self currentNetworkReachabilityStatus]);
}

+ (BOOL)isInternetConnectionReachable
{
        return ([self currentNetworkReachabilityStatus] != ESNetworkReachabilityStatusNotReachable);
}

@end


NSString *ESNetworkReachabilityStatusString(ESNetworkReachabilityStatus status)
{
        switch (status) {
                case ESNetworkReachabilityStatusReachableViaWiFi:
                        return ESNetworkReachabilityStatusStringReachableViaWiFi;
                case ESNetworkReachabilityStatusReachableViaWWAN:
                        return ESNetworkReachabilityStatusStringReachableViaWWAN;
                default:
                        return ESNetworkReachabilityStatusStringNotReachable;
        }
}
