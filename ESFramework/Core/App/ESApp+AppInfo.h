//
//  ESApp+AppInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@interface ESApp (AppInfo)

+ (NSBundle *)mainBundle;
+ (NSDictionary *)infoDictionary;
+ (id)objectForInfoDictionaryKey:(NSString *)key;
+ (NSString *)displayName;
+ (NSString *)appVersion;
/// https://developer.apple.com/library/mac/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW29
+ (BOOL)isUIViewControllerBasedStatusBarAppearance;
+ (NSString *)bundleIdentifier;

/**
 * e.g.
 *
 * @code
 * {
 *     "app_channel" = "App Store";
 *     "app_identifier" = "com.0x123.xunleivip";
 *     "app_name" = "Thuner VIP";
 *     "app_version" = "1.0.0";
 *     carrier = "China Mobile";
 *     jailbroken = 1;
 *     locale = "zh_CN";
 *     model = iPhone;
 *     name = "Elf Sundae's iPhone";
 *     network = WiFi;
 *     "open_udid" = c0f9e011b8a17a904e2b4fe9fdf15640300a7c34;
 *     os = iOS;
 *     "os_version" = "8.1.2";
 *     platform = "iPhone7,1";
 *     "screen_size" = 1242x2208;
 *     "timezone_gmt" = 8;
 * }
 * @endcode
 *
 */
- (NSDictionary *)analyticsInformation;
/**
 * Returns User Agent for UIWebView.
 *
 * Default User Agent for UIWebView, it registered after app launched.
 * Subclass can return #nil to use the default user-agent for UIWebView.
 *
 * e.g. `Mozilla/5.0 (iPhone; CPU iPhone OS 8_1_2 like Mac OS X) Mobile/12B440 ESFramework(iOS;8.1.2;com.0x123.ESDemo;1.0.0;App Store;c0f9e011b8a17a904e2b4fe9fdf15640300a7c34;1242x2208;zh_CN)`
 */
- (NSString *)userAgentForWebView;

/**
 * Returns User Agent for HTTP request.
 *
 * e.g. `ESFramework(iOS;8.1.2;com.0x123.ESDemo;1.0.0;App Store;c0f9e011b8a17a904e2b4fe9fdf15640300a7c34;1242x2208;zh_CN)`
 */
- (NSString *)userAgent;
/**
 * Returns all URL Schemes that specified in the Info.plist.
 *
 * @param identifier can be `nil`, `@""`, or a string
 */
+ (NSArray *)URLSchemesForIdentifier:(NSString *)identifier;

/**
 * All URL schemes in the Info.plist.
 */
+ (NSArray *)allURLSchemes;

@end
