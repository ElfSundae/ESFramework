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
 * Returns the IP addresses of all actived network interfaces.
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
 * Returns the IP addresses for the network interfaces.
 * { interfaceName: { addressFamily: address, ... } }
 *
 * @param interfacesPredicate Optional NSSet filter of network interface names. If this param is nil or an empty set, all interfaces and associated IP addresses will be returned.
 */
+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddressesForNetworkInterfaces:(nullable NSSet *)interfacesPredicate;

/**
 * Returns the local IPv4 address of the "en0" network interface.
 * You may optionally pass `IPv6Address` out param to get the IPv6 address.
 */
+ (nullable NSString *)getLocalIPAddress:(NSString * _Nullable * _Nullable)IPv6Address;

/**
 * Returns the current WiFi network info.
 *
 * @code
 * // Example result:
 * {
 *     BSSID = "20:c9:d0:e1:78:c9";
 *     SSID = "Elf Sundae's MBP";
 *     SSIDDATA = <456c6620 53756e64 61652773 204d4250>;
 * }
 * @endcode
 *
 * @warning To use this function in iOS 12 and later, enable the Access WiFi Information capability in Xcode.
 * For more information, see https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info
 */
+ (nullable NSDictionary *)getWiFiNetworkInfo;

/**
 * Returns the current WiFi SSID.
 *
 * @warning To use this function in iOS 12 and later, enable the Access WiFi Information capability in Xcode.
 * For more information, see https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info
 */
+ (nullable NSString *)getWiFiSSID;

/**
 * Returns the current WiFi BSSID.
 *
 * @warning To use this function in iOS 12 and later, enable the Access WiFi Information capability in Xcode.
 * For more information, see https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info
 */
+ (nullable NSString *)getWiFiBSSID;

@end

NS_ASSUME_NONNULL_END
