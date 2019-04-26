//
//  ESNetworkHelper.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/26.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * ESNetworkAddressFamily NS_EXTENSIBLE_STRING_ENUM;

/// "IPv4"
FOUNDATION_EXTERN ESNetworkAddressFamily const ESNetworkAddressFamilyIPv4;
/// "IPv6"
FOUNDATION_EXTERN ESNetworkAddressFamily const ESNetworkAddressFamilyIPv6;

/// "lo0"
FOUNDATION_EXTERN NSString *const ESNetworkInterfaceLoopbackName;
/// "awdl0" (Apple Wireless Direct Link)
FOUNDATION_EXTERN NSString *const ESNetworkInterfaceAWDLName;
/// "en0"
FOUNDATION_EXTERN NSString *const ESNetworkInterfaceWiFiName;
/// "pdp_ip0"
FOUNDATION_EXTERN NSString *const ESNetworkInterfaceCellularName;
/// "utun0"
FOUNDATION_EXTERN NSString *const ESNetworkInterfaceVPNName;

@interface ESNetworkHelper : NSObject

/**
 * Returns the IP addresses of the network interfaces.
 * { interfaceName: { addressFamily: address, ... } }
 *
 * @code
 * // Example result:
 * {
 *     awdl0 =     {
 *         IPv6 = "fe80::9893:97ff:fe3b:e2a8";
 *     };
 *     en0 =     {
 *         IPv4 = "192.168.1.127";
 *         IPv6 = "fe80::449:7487:aaeb:a91";
 *     };
 *     lo0 =     {
 *         IPv4 = "127.0.0.1";
 *         IPv6 = "::1";
 *     };
 *     utun0 =     {
 *         IPv6 = "fe80::2390:e96c:4e93:8be0";
 *     };
 *     ipsec1 =     {
 *         IPv6 = "fe80::923c:92ff:fe46:87e";
 *     };
 * }
 * @endcode
 */
+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddresses;

/**
 * Returns the IPv4 address of "en0" network interface.
 */
+ (nullable NSString *)getLocalIPv4Address;

/**
 * Returns the IPv6 address of "en0" network interface.
 */
+ (nullable NSString *)getLocalIPv6Address;

@end

NS_ASSUME_NONNULL_END
