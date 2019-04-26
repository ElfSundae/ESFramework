//
//  ESNetworkHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/26.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "ESNetworkHelper.h"
#include <ifaddrs.h>
#include <net/if.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>

ESNetworkAddressFamily const ESNetworkAddressFamilyIPv4 = @"IPv4";
ESNetworkAddressFamily const ESNetworkAddressFamilyIPv6 = @"IPv6";

NSString *const ESNetworkInterfaceLoopbackName = @"lo0";
NSString *const ESNetworkInterfaceAWDLName = @"awdl0";
NSString *const ESNetworkInterfaceWiFiName = @"en0";
NSString *const ESNetworkInterfaceCellularName = @"pdp_ip0";
NSString *const ESNetworkInterfaceVPNName = @"utun0";

@implementation ESNetworkHelper

+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddresses
{
    return [self getIPAddressesForNetworkInterfaces:nil];
}

// ref: http://man7.org/linux/man-pages/man3/getifaddrs.3.html
// ref: https://stackoverflow.com/a/10803584/521946
+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddressesForNetworkInterfaces:(nullable NSSet *)interfacesPredicate
{
    struct ifaddrs *ifaddr;
    if (0 != getifaddrs(&ifaddr)) {
        return nil;
    }

    NSMutableDictionary *addresses = [NSMutableDictionary dictionary];

    // Loop through linked list of interfaces
    struct ifaddrs *interface;
    for (interface = ifaddr; interface != NULL; interface = interface->ifa_next) {
        if (NULL == interface->ifa_addr ||
            IFF_UP != (interface->ifa_flags & IFF_UP)) {
            continue;
        }

        NSString *name = [NSString stringWithUTF8String:interface->ifa_name];

        if (interfacesPredicate.count && ![interfacesPredicate containsObject:name]) {
            continue;
        }

        ESNetworkAddressFamily family = nil;
        NSString *address = nil;

        if (AF_INET == interface->ifa_addr->sa_family) {
            const struct sockaddr_in *addr = (const struct sockaddr_in *)interface->ifa_addr;
            char addrBuf[INET_ADDRSTRLEN];
            if (inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                family = ESNetworkAddressFamilyIPv4;
                address = [NSString stringWithUTF8String:addrBuf];
            }
        } else if (AF_INET6 == interface->ifa_addr->sa_family) {
            const struct sockaddr_in6 *addr = (const struct sockaddr_in6 *)interface->ifa_addr;
            char addrBuf[INET6_ADDRSTRLEN];
            if (inet_ntop(AF_INET6, &addr->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                family = ESNetworkAddressFamilyIPv6;
                address = [NSString stringWithUTF8String:addrBuf];
            }
        }

        if (!family || !address) {
            continue;
        }

        if (addresses[name][family]) {
            // we only get the first IP address for one interface
            continue;
        }

        if (!addresses[name]) {
            addresses[name] = [NSMutableDictionary dictionary];
        }

        addresses[name][family] = address;
    } /* for-loop */
    freeifaddrs(ifaddr);

    return addresses.copy;
}

+ (NSString *)getLocalIPAddress:(NSString * _Nullable * _Nullable)IPv6Address
{
    NSDictionary *addresses = [[self getIPAddressesForNetworkInterfaces:[NSSet setWithObjects:ESNetworkInterfaceWiFiName, nil]]
                               objectForKey:ESNetworkInterfaceWiFiName];
    if (IPv6Address) {
        *IPv6Address = addresses[ESNetworkAddressFamilyIPv6];
    }
    return addresses[ESNetworkAddressFamilyIPv4];
}

+ (nullable NSDictionary *)getWiFiNetworkInfo
{
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces) {
        CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo((CFStringRef)CFArrayGetValueAtIndex(interfaces, 0));
        CFRelease(interfaces);
        return CFBridgingRelease(networkInfo);
    }
    return nil;
}

+ (nullable NSString *)getWiFiSSID
{
    return [self getWiFiNetworkInfo][(__bridge NSString *)kCNNetworkInfoKeySSID];
}

+ (nullable NSString *)getWiFiBSSID
{
    return [self getWiFiNetworkInfo][(__bridge NSString *)kCNNetworkInfoKeyBSSID];
}

@end
