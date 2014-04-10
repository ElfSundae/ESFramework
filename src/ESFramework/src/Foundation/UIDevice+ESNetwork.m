//
//  UIDevice+ESNetwork.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "UIDevice+ESNetwork.h"

static Reachability *__sharedReachability = nil;

@implementation UIDevice (ESNetwork)

+ (void)load
{
        __sharedReachability = [Reachability reachabilityForInternetConnection];
}

+ (NetworkStatus)currentNetworkStatus
{
        return __sharedReachability.currentReachabilityStatus;
}

+ (NSString *)currentNetworkStatusString
{
        NetworkStatus status = [self currentNetworkStatus];
        NSString *result = @"None";
        if (kReachableViaWiFi == status) {
                result = @"WiFi";
        } else if (kReachableViaWWAN == status) {
                result = @"WWAN";
        }
        return result;
}

@end
