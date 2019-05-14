//
//  UIApplication+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ESAdditions)

@end

@interface UIApplication (ESAppInfo)

/// The name of the executable in the main bundle.
@property (readonly) NSString *appName;
@property (readonly) NSString *appBundleName;
@property (readonly) NSString *appDisplayName;
@property (readonly) NSString *appBundleIdentifier;
@property (readonly) NSString *appVersion;
@property (readonly) NSString *appBuildVersion;
/// e.g. "1.2.4 (210)"
@property (readonly) NSString *appFullVersion;
@property (readonly) BOOL isUIViewControllerBasedStatusBarAppearance;

@property (nonatomic, readonly) NSDate *appLaunchDate;
@property (nonatomic, readonly) NSTimeInterval appLaunchDuration;

/**
 * Indicates whether the current app launch is a "fresh launch" which means the
 * first time of app launch after the app was installed or upgraded.
 */
@property (nonatomic, readonly) BOOL isFreshLaunch;

/**
 * Returns the app version before the current launching.
 */
@property (nullable, nonatomic, readonly) NSString *appPreviousVersion;

/**
 * Returns the app analytics information.
 * @code
 * {
 *     "os" : "iOS",
 *     "os_version" : "12.2",
 *     "model" : "iPhone",
 *     "model_identifier" : "iPhone9,2",
 *     "model_name" : "iPhone 7 Plus",
 *     "device_name" : "Elf Sundae's iPhone",
 *     "jailbroken" : 0,
 *     "screen_size" : "414x736",
 *     "screen_scale" : "3.00",
 *     "timezone_gmt" : 8,
 *     "locale" : "zh_CN",
 *     "app_name" : "iOS Example",
 *     "app_identifier" : "com.0x123.ESFramework",
 *     "app_version" : "2.1",
 *     "app_build_version" : 45,
 *     "app_launch" : "0.27",
 *     "app_fresh_launch" : 1,
 *     "app_previous_version" : "1.3",
 *     "network" : "WiFi",
 *     "wwan" : "4G",
 *     "carrier" : "中国电信",
 *     "ssid" : "Elf Sundae's MBP",
 *     "bssid" : "20:c9:d0:e1:78:c9",
 *     "local_ip" : "192.168.2.21",
 *     "local_ipv6" : "fe80::1c04:cf4e:2d7c:c533",
 *     "wwan_ip" : "10.14.58.61",
 *     "wwan_ipv6" : "fe80::18e8:e230:e459:4f68",
 * }
 * @endcode
 */
- (NSDictionary *)analyticsInfo;

@end

NS_ASSUME_NONNULL_END
