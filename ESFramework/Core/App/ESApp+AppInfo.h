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
 *     os = iOS;
 *     "os_version" = "7.1";
 *     "app_channel" = "App Store";
 *     "app_identifier" = "com.0x123.ESDemo";
 *     "app_name" = "ES Demo";
 *     "app_version" = "1.0.0";
 *     carrier = "";
 *     jailbroken = 0;
 *     locale = "en_US";
 *     model = "iPhone Simulator";
 *     name = "iPhone Simulator";
 *     network = WiFi;
 *     platform = "x86_64";
 *     "screen_size" = 640x1136;
 *     "timezone_gmt" = 8;
 *     udid = 266caef7e386667663d6f994f8d2b2cac4e89a9f;
 * }
 * @endcode
 *
 * Note: The 'network' requires UIDevice(Reachability), which included in ESFrameworkNetwork.
 */
- (NSMutableDictionary *)analyticsInformation;
/**
 * Returns User Agent for UIWebView.
 *
 * Default User Agent for UIWebView, it registered after app launched.
 * Subclass can return #nil to use the default user-agent for UIWebView.
 *
 * e.g. `Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_1 like Mac OS X) Mobile/11D201 ESFramework(iOS;7.1;com.0x123.ESDemo;1.0.0;App Store;266caef7e386667663d6f994f8d2b2cac4e89a9f;640x1136;en_US)`
 */
- (NSString *)userAgentForWebView;

/**
 * Returns User Agent for HTTP request.
 *
 * e.g. `ESFramework(iOS;7.1;com.0x123.ESDemo;1.0.0;App Store;266caef7e386667663d6f994f8d2b2cac4e89a9f;640x1136;en_US)`
 */
- (NSString *)userAgent;
/**
 * Returns all URL Schemes that specified in the Info.plist.
 */
+ (NSArray *)URLSchemesForIdentifier:(NSString *)identifier;
/**
 * Returns all URL Schemes for the blank or NULL identifier.
 */
+ (NSArray *)URLSchemes;
/**
 * The first scheme for the identifier.
 */
+ (NSString *)URLSchemeForIdentifier:(NSString *)identifier;
/**
 * The first scheme for the blank or NULL identifier.
 * In general, this may be the App Scheme that used to open this app
 * from another app (like Safari, -[UIApplication openURL:])
 */
+ (NSString *)URLScheme;

@end
