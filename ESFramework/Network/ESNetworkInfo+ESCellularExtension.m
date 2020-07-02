//
//  ESNetworkInfo+ESCellularExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2020/07/03.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import "ESNetworkInfo.h"
#if TARGET_OS_IOS

#import "ESNetworkInterface.h"
#import "NSArray+ESExtension.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CTTelephonyNetworkInfo+ESExtension.h"

@implementation ESNetworkInfo (ESCellularExtension)

+ (nullable NSString *)carrierName
{
    return CTTelephonyNetworkInfo.new.dataServiceSubscriberCellularProvider.carrierName;
}

+ (nullable NSString *)cellularIPAddresses:(NSString * _Nullable * _Nullable)IPv6Addresses
{
    ESNetworkInterface *interface = [[self networkInterfaces] objectPassingTest:^BOOL (ESNetworkInterface * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:ESNetworkInterfaceCellular]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];

    if (IPv6Addresses) {
        *IPv6Addresses = interface.IPv6Address;
    }

    return interface.IPv4Address;
}

+ (ESCellularNetworkType)cellularNetworkType
{
    NSString *name = CTTelephonyNetworkInfo.new.dataServiceCurrentRadioAccessTechnology;
    if (!name) {
        return ESCellularNetworkTypeNone;
    } else if ([name isEqualToString:CTRadioAccessTechnologyGPRS] ||
               [name isEqualToString:CTRadioAccessTechnologyEdge]) {
        return ESCellularNetworkType2G;
    } else if ([name isEqualToString:CTRadioAccessTechnologyWCDMA] ||
               [name isEqualToString:CTRadioAccessTechnologyHSDPA] ||
               [name isEqualToString:CTRadioAccessTechnologyHSUPA] ||
               [name isEqualToString:CTRadioAccessTechnologyCDMA1x] ||
               [name isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
               [name isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
               [name isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
               [name isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        return ESCellularNetworkType3G;
    } else if ([name isEqualToString:CTRadioAccessTechnologyLTE]) {
        return ESCellularNetworkType4G;
    } else {
        return ESCellularNetworkTypeUnknown;
    }
}

+ (NSString *)cellularNetworkTypeString
{
    switch ([self cellularNetworkType]) {
        case ESCellularNetworkTypeNone:
            return @"None";
        case ESCellularNetworkType2G:
            return @"2G";
        case ESCellularNetworkType3G:
            return @"3G";
        case ESCellularNetworkType4G:
            return @"4G";
        case ESCellularNetworkTypeUnknown:
        default:
            return @"Unknown";
    }
}

@end

#endif
