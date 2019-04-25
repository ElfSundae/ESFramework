//
//  UIDevice+ESInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kESNetworkInterfaceFamilyIPv4           @"IPv4"
#define kESNetworkInterfaceFamilyIPv6           @"IPv6"
#define kESNetworkInterfaceNameLoopback         @"lo0" // localhost
#define kESNetworkInterfaceNameCellular         @"pdp_ip0"
#define kESNetworkInterfaceNameWiFi             @"en0"
#define kESNetworkInterfaceNameVPN              @"utun0"
#define kESNetworkInterfaceNameAWDL             @"awdl0" // AWDL (Apple Wireless Direct Link)

@interface UIDevice (ESInfo)

/**
 * e.g. @"iPhone3,1", @"x86_64".
 * http://theiphonewiki.com/wiki/Models
 */
- (NSString *)platform;

/**
 * Returns an array contains the name of the subscriber's cellular service provider.
 * e.g. @[ @"ChinaNet", @"AT&T" ]
 */
- (nullable NSArray<NSString *> *)carrierNames;

/**
 * Returns the name of the subscriber's main (first) cellular service provider.
 * e.g. @"AT&T"
 */
- (nullable NSString *)carrierName;

/**
 * Returns the current WiFi network info.
 *
 * @code
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
- (nullable NSDictionary *)WiFiNetworkInfo;

/**
 * Returns the current WiFi SSID.
 *
 * @warning To use this function in iOS 12 and later, enable the Access WiFi Information capability in Xcode.
 * For more information, see https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info
 */
- (nullable NSString *)WiFiSSID;

/**
 * Returns the current WiFi BSSID.
 *
 * @warning To use this function in iOS 12 and later, enable the Access WiFi Information capability in Xcode.
 * For more information, see https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info
 */
- (nullable NSString *)WiFiBSSID;

/**
 * Detects whether this device has been jailbroken.
 */
- (BOOL)isJailbroken;

/**
 * Returns the free size of the disk.
 */
- (long long)diskFreeSize;

/**
 * Returns a string whose value indicates the free size of the disk,
 * e.g. "11.23 GB"
 */
- (NSString *)diskFreeSizeString;

/**
 * Returns the total size of the disk.
 */
- (long long)diskSize;

/**
 * Returns a string whose value indicates the total size of the disk,
 * e.g. "63.99 GB"
 */
- (NSString *)diskSizeString;

/**
 * the screen size in points.
 */
- (CGSize)screenSizeInPoints;

/**
 * The screen size in pixels.
 */
- (CGSize)screenSizeInPixels;

/**
 * Returns network interfaces names and addresses.
 *
 * e.g.
 * @code
 * {
 *     IPv4 = {
 *         en0 = "192.168.2.115";
 *         lo0 = "127.0.0.1";
 *         "pdp_ip0" = "100.114.247.226";
 *     };
 *     IPv6 = {
 *         awdl0 = "fe80::5c75:e1ff:fe4e:f45a";
 *         en0 = "fe80::881:8a52:89cb:bb89";
 *         lo0 = "fe80::1";
 *     };
 * }
 * @endcode
 */
- (NSDictionary *)getNetworkInterfacesIncludesLoopback:(BOOL)includesLoopback;

/**
 * Returns IPv4 address on en0.
 */
- (NSString *)localIPv4Address;

/**
 * Returns IPv6 address on en0.
 */
- (NSString *)localIPv6Address;

@end

NS_ASSUME_NONNULL_END
