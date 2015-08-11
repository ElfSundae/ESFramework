//
//  UIDevice+ESNetworkReachability.m
//  ESFramework
//
//  Created by Elf Sundae on 4/22/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "UIDevice+ESNetworkReachability.h"

ES_CATEGORY_FIX(UIDevice_ESNetworkReachability)

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
        ESNetworkReachabilityStatus status = [self currentNetworkReachabilityStatus];
        if (ESNetworkReachabilityStatusReachableViaWiFi == status) {
                return ESNetworkReachabilityStatusStringReachableViaWiFi;
        } else if (ESNetworkReachabilityStatusReachableViaWWAN == status) {
                return ESNetworkReachabilityStatusStringReachableViaWWAN;
        } else if (ESNetworkReachabilityStatusNotReachable == status) {
                return ESNetworkReachabilityStatusStringNotReachable;
        } else {
                return @"Unknown";
        }
}

@end
