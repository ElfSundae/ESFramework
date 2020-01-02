//
//  ESNetworkHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/26.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "ESNetworkHelper.h"
#if !TARGET_OS_WATCH

#import <ifaddrs.h>
#import <net/if.h>
#import <arpa/inet.h>
#if TARGET_OS_IOS
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#endif

ESNetworkAddressFamily const ESNetworkAddressFamilyIPv4 = @"IPv4";
ESNetworkAddressFamily const ESNetworkAddressFamilyIPv6 = @"IPv6";

NSString *const ESNetworkInterfaceLoopback  = @"lo0";
NSString *const ESNetworkInterfaceAWDL      = @"awdl0";
#if TARGET_OS_IOS || TARGET_OS_TV
NSString *const ESNetworkInterfaceWiFi      = @"en0";
#else
NSString *const ESNetworkInterfaceWiFi      = @"en1";
#endif
NSString *const ESNetworkInterfaceCellular  = @"pdp_ip0";
NSString *const ESNetworkInterfaceVPN       = @"utun0";

@implementation ESNetworkHelper

+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddresses
{
    return [self getIPAddressesForInterfaces:nil];
}

+ (nullable NSDictionary<ESNetworkAddressFamily, NSString *> *)getIPAddressesForInterface:(NSString *)interface
{
    return [[self getIPAddressesForInterfaces:[NSSet setWithObjects:interface, nil]] objectForKey:interface];
}

// ref: http://man7.org/linux/man-pages/man3/getifaddrs.3.html
// ref: https://stackoverflow.com/a/10803584/521946
+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddressesForInterfaces:(nullable NSSet<NSString *> *)interfacesPredicate
{
    struct ifaddrs *ifaddr;
    if (0 != getifaddrs(&ifaddr)) {
        return nil;
    }

    NSMutableDictionary *addresses = [NSMutableDictionary dictionary];

    // Loop through linked list of interfaces
    struct ifaddrs *interface;
    for (interface = ifaddr; interface != NULL; interface = interface->ifa_next) {
        if (NULL == interface->ifa_addr || IFF_UP != (interface->ifa_flags & IFF_UP)) {
            continue;
        }

        NSString *name = @(interface->ifa_name);

        if (interfacesPredicate && ![interfacesPredicate containsObject:name]) {
            continue;
        }

        ESNetworkAddressFamily family = nil;
        NSString *address = nil;

        if (AF_INET == interface->ifa_addr->sa_family) {
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[INET_ADDRSTRLEN];
            if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                family = ESNetworkAddressFamilyIPv4;
                address = @(addrBuf);
            }
        } else if (AF_INET6 == interface->ifa_addr->sa_family) {
            const struct sockaddr_in6 *addr = (const struct sockaddr_in6 *)interface->ifa_addr;
            char addrBuf[INET6_ADDRSTRLEN];
            if (inet_ntop(AF_INET6, &addr->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                family = ESNetworkAddressFamilyIPv6;
                address = @(addrBuf);
            }
        }

        if (!family || !address) {
            continue;
        }

        if (addresses[name][family]) {
            // we only get the first IP address for the interface
            continue;
        }

        if (!addresses[name]) {
            addresses[name] = [NSMutableDictionary dictionary];
        }

        addresses[name][family] = address;
    } /* for-loop */

    freeifaddrs(ifaddr);

    return [addresses copy];
}

+ (NSString *)getIPAddressForWiFi:(NSString **)IPv6Address
{
    NSDictionary *addresses = [self getIPAddressesForInterface:ESNetworkInterfaceWiFi];
    if (IPv6Address) {
        *IPv6Address = addresses[ESNetworkAddressFamilyIPv6];
    }
    return addresses[ESNetworkAddressFamilyIPv4];
}

#if TARGET_OS_IOS

+ (NSString *)getIPAddressForCellular:(NSString **)IPv6Address
{
    NSDictionary *addresses = [self getIPAddressesForInterface:ESNetworkInterfaceCellular];
    if (IPv6Address) {
        *IPv6Address = addresses[ESNetworkAddressFamilyIPv6];
    }
    return addresses[ESNetworkAddressFamilyIPv4];
}

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
    return CTTelephonyNetworkInfo.new.subscriberCellularProvider.carrierName;
}

+ (ESCellularNetworkType)getCellularNetworkType
{
    NSString *name = CTTelephonyNetworkInfo.new.currentRadioAccessTechnology;
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

#endif
