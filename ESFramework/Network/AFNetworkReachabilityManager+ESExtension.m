//
//  AFNetworkReachabilityManager+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/10.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "AFNetworkReachabilityManager+ESExtension.h"

NSString *ESStringFromNetworkReachabilityStatus(AFNetworkReachabilityStatus status)
{
    switch (status) {
        case AFNetworkReachabilityStatusNotReachable:
            return @"None";
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"WWAN";
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WiFi";
        case AFNetworkReachabilityStatusUnknown:
        default:
            return @"Unknown";
    }
}

@implementation AFNetworkReachabilityManager (ESExtension)

- (NSString *)networkReachabilityStatusString
{
    return ESStringFromNetworkReachabilityStatus(self.networkReachabilityStatus);
}

@end
