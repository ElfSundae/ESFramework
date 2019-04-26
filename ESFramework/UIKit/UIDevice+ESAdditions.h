//
//  UIDevice+ESInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ESAdditions)

/**
 * e.g. @"iPhone3,1", @"x86_64".
 * http://theiphonewiki.com/wiki/Models
 */
@property (nonatomic, copy, readonly) NSString *platform;

/**
 * Returns the free size of the disk.
 */
@property (nonatomic, readonly) long long diskFreeSize;

/**
 * Returns a string whose value indicates the free size of the disk,
 * e.g. "11.23 GB"
 */
@property (nonatomic, copy, readonly) NSString *diskFreeSizeString;

/**
 * Returns the total size of the disk.
 */
@property (nonatomic, readonly) long long diskSize;

/**
 * Returns a string whose value indicates the total size of the disk,
 * e.g. "63.99 GB"
 */
@property (nonatomic, copy, readonly) NSString *diskSizeString;

/**
 * the screen size in points.
 */
@property (nonatomic, readonly) CGSize screenSizeInPoints;

/**
 * The screen size in pixels.
 */
@property (nonatomic, readonly) CGSize screenSizeInPixels;

/**
 * Detects whether this device has been jailbroken.
 */
@property (nonatomic, readonly) BOOL isJailbroken;

/**
 * Returns the name of the subscriber's main (first) cellular service provider.
 * e.g. @"AT&T"
 */
@property (nullable, nonatomic, copy, readonly) NSString *carrierName;

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
@property (nullable, nonatomic, copy, readonly) NSDictionary *WiFiNetworkInfo;

/**
 * Returns the current WiFi SSID.
 *
 * @warning To use this function in iOS 12 and later, enable the Access WiFi Information capability in Xcode.
 * For more information, see https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info
 */
@property (nullable, nonatomic, copy, readonly) NSString *WiFiSSID;

/**
 * Returns the current WiFi BSSID.
 *
 * @warning To use this function in iOS 12 and later, enable the Access WiFi Information capability in Xcode.
 * For more information, see https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_networking_wifi-info
 */
@property (nullable, nonatomic, copy, readonly) NSString *WiFiBSSID;

@end

NS_ASSUME_NONNULL_END
