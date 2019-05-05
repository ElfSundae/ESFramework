//
//  ESNetworkHelper.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/26.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ESCellularNetworkType) {
    ESCellularNetworkTypeUnknown  = -1,
    ESCellularNetworkTypeNone     = 0,
    ESCellularNetworkType2G       = 2,
    ESCellularNetworkType3G       = 3,
    ESCellularNetworkType4G       = 4,
};

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
 * { interface: { family: address, ... } }
 *
 * @code
 * // Example result:
 * {
 *     awdl0 =     {
 *         IPv6 = "fe80::406b:fff:fea5:75e1";
 *     };
 *     en0 =     {
 *         IPv4 = "192.168.2.2";
 *         IPv6 = "fe80::105b:74b3:6866:5c74";
 *     };
 *     en2 =     {
 *         IPv4 = "169.254.230.211";
 *         IPv6 = "fe80::8f1:c91:6c6b:6dff";
 *     };
 *     ipsec1 =     {
 *         IPv6 = "fe80::923c:92ff:fe46:87e";
 *     };
 *     ipsec2 =     {
 *         IPv6 = "fe80::923c:92ff:fe46:87e";
 *     };
 *     lo0 =     {
 *         IPv4 = "127.0.0.1";
 *         IPv6 = "::1";
 *     };
 *     "pdp_ip0" =     {
 *         IPv4 = "10.62.227.126";
 *         IPv6 = "fe80::5f:8e75:5dcd:e3fa";
 *     };
 *     "pdp_ip1" =     {
 *         IPv6 = "fe80::80f:8a47:ad66:9eed";
 *     };
 *     utun0 =     {
 *         IPv6 = "fe80::67e2:1942:c9d5:a602";
 *     };
 *     utun1 =     {
 *         IPv6 = "fe80::f9b8:325d:ff9f:96fc";
 *     };
 *     utun2 =     {
 *         IPv4 = "240.0.0.1";
 *     };
 * }
 * @endcode
 */
+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddresses;

/**
 * Returns the IP addresses for the network interfaces.
 * { interface: { family: address, ... } }
 *
 * @param interfacesPredicate Optional NSSet filter of network interface names. If this param is nil or an empty set, all interfaces and associated IP addresses will be returned.
 */
+ (nullable NSDictionary<NSString *, NSDictionary<ESNetworkAddressFamily, NSString *> *> *)getIPAddressesForInterfaces:(nullable NSSet<NSString *> *)interfacesPredicate;

/**
 * Returns the IP addresses for the network interface.
 * { family: address, ... }
 */
+ (nullable NSDictionary<ESNetworkAddressFamily, NSString *> *)getIPAddressesForInterface:(NSString *)interface;

/**
 * Returns the local IPv4 address of the "en0" network interface.
 * You may optionally pass `IPv6Address` out param to get the IPv6 address.
 */
+ (nullable NSString *)getIPAddressForWiFi:(NSString * _Nullable * _Nullable)IPv6Address;

/**
 * Returns the local IPv4 address of the "pdp_ip0" network interface.
 * You may optionally pass `IPv6Address` out param to get the IPv6 address.
 */
+ (nullable NSString *)getIPAddressForCellular:(NSString * _Nullable * _Nullable)IPv6Address;

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

/**
 * Returns the name of the cellular service provider.
 * e.g. "AT&T"
 */
+ (nullable NSString *)getCarrierName;

/**
 * Returns the current cellular network type.
 */
+ (ESCellularNetworkType)currentCellularNetworkType;

@end

NS_ASSUME_NONNULL_END
