//
//  ESNetworkInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/26.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "ESNetworkInfo.h"
//#if !TARGET_OS_WATCH

#import <ifaddrs.h>
#import <net/if.h>
#import <arpa/inet.h>
#import "ESNetworkInterface.h"
#import "NSArray+ESExtension.h"

#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "CTTelephonyNetworkInfo+ESExtension.h"
#endif

@implementation ESNetworkInfo

// ref: http://man7.org/linux/man-pages/man3/getifaddrs.3.html
// ref: https://stackoverflow.com/a/10803584/521946
+ (NSArray<ESNetworkInterface *> *)networkInterfaces;
{
    struct ifaddrs *ifaddr;
    if (0 != getifaddrs(&ifaddr)) {
        return @[];
    }

    NSMutableDictionary<NSString *, ESNetworkInterface *> *networkInterfaces = [NSMutableDictionary dictionary];

    // Loop through linked list of interfaces
    struct ifaddrs *interface;
    for (interface = ifaddr; interface != NULL; interface = interface->ifa_next) {
        if (NULL == interface->ifa_addr || IFF_UP != (interface->ifa_flags & IFF_UP)) {
            continue;
        }

        NSString *name = @(interface->ifa_name);
        ESNetworkInterface *networkInterface = networkInterfaces[name] ?: [[ESNetworkInterface alloc] initWithName:name];

        // NOTE: We only get the first IP address for the interface.

        if (AF_INET == interface->ifa_addr->sa_family && !networkInterface.IPv4Address) {
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[INET_ADDRSTRLEN];
            if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                networkInterface.IPv4Address = @(addrBuf);
            }
        } else if (AF_INET6 == interface->ifa_addr->sa_family && !networkInterface.IPv6Address) {
            const struct sockaddr_in6 *addr = (const struct sockaddr_in6 *)interface->ifa_addr;
            char addrBuf[INET6_ADDRSTRLEN];
            if (inet_ntop(AF_INET6, &addr->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                networkInterface.IPv6Address = @(addrBuf);
            }
        }

        if (networkInterface.IPv4Address || networkInterface.IPv6Address) {
            networkInterfaces[name] = networkInterface;
        }
    }

    freeifaddrs(ifaddr);

    return networkInterfaces.allValues;
}

+ (NSArray<NSString *> *)localIPAddresses:(NSArray<NSString *> * _Nullable * _Nullable)IPv6Addresses
{
    NSArray<ESNetworkInterface *> *interfaces = [[self networkInterfaces] objectsPassingTest:^BOOL (ESNetworkInterface * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return [obj.name isEqualToString:@"en0"] || [obj.name isEqualToString:@"en1"];
    }];

    if (IPv6Addresses) {
        *IPv6Addresses = [interfaces valueForKeyPath:@"@unionOfObjects.IPv6Address"];
    }

    return [interfaces valueForKeyPath:@"@unionOfObjects.IPv4Address"];
}

#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST

+ (nullable NSDictionary<NSString *, id> *)getWiFiNetworkInfo
{
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (!interfaces) {
        return nil;
    }
    CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo((CFStringRef)CFArrayGetValueAtIndex(interfaces, 0));
    CFRelease(interfaces);
    return CFBridgingRelease(networkInfo);
}

+ (nullable NSString *)getWiFiSSID
{
    return [self getWiFiNetworkInfo][(__bridge NSString *)kCNNetworkInfoKeySSID];
}

+ (nullable NSString *)getWiFiBSSID
{
    return [self getWiFiNetworkInfo][(__bridge NSString *)kCNNetworkInfoKeyBSSID];
}

+ (nullable NSString *)getCarrierName
{
    return CTTelephonyNetworkInfo.new.dataServiceSubscriberCellularProvider.carrierName;
}

+ (ESCellularNetworkType)getCellularNetworkType
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

+ (NSString *)getCellularNetworkTypeString
{
    switch ([self getCellularNetworkType]) {
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

#endif

@end

//#endif
