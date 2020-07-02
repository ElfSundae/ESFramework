//
//  ESNetworkInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/26.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

//#if !TARGET_OS_WATCH

@class ESNetworkInterface;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ESCellularNetworkType) {
    ESCellularNetworkTypeUnknown  = -1,
    ESCellularNetworkTypeNone     = 0,
    ESCellularNetworkType2G       = 2,
    ESCellularNetworkType3G       = 3,
    ESCellularNetworkType4G       = 4,
} API_UNAVAILABLE(macos, tvos);

@interface ESNetworkInfo : NSObject

/**
 * Returns all actived network interfaces.
 */
+ (NSArray<ESNetworkInterface *> *)networkInterfaces;

/**
 * Returns all local IPv4 addresses of the "en0" and "en1" interfaces.
 * You may optionally pass `IPv6Addresses` out param to get IPv6 addresses.
 */
+ (NSArray<NSString *> *)localIPAddresses:(NSArray<NSString *> * _Nullable * _Nullable)IPv6Addresses;

#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST

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
+ (nullable NSDictionary<NSString *, id> *)getWiFiNetworkInfo;

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
 * e.g. "AT&T", "ChinaNet"
 */
+ (nullable NSString *)getCarrierName;

/**
 * Returns the current cellular network type.
 */
+ (ESCellularNetworkType)getCellularNetworkType;

/**
 * Returns the current cellular network type as string.
 */
+ (NSString *)getCellularNetworkTypeString;

#endif

@end

NS_ASSUME_NONNULL_END

//#endif
