//
//  UIApplication+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const ESAppPreviousVersionUserDefaultsKey;

@interface UIApplication (ESAdditions)

/**
 * The window used to present the app’s visual content on the device’s main screen.
 * @discusion Shortcut for the `delegate.window`.
 */
@property (nullable, nonatomic, strong) UIWindow *appWindow;

/**
 * The root view controller provides the content view of the appWindow.
 * @discusion Shortcut for the `delegate.window.rootViewController`.
 */
@property (nullable, nonatomic, strong) UIViewController *rootViewController;

/**
 * Returns the topmost view controller in the appWindow's hierarchy.
 * @discusion You may use this view controller to present modal view controllers.
 */
- (nullable UIViewController *)topmostViewController;

/**
 * Presents a view controller modally from the rootViewControllerForPresenting.
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 * Dismisses all modal view controllers.
 */
- (void)dismissViewControllersAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion;

/**
 * Dismiss the keyboard.
 */
- (void)dismissKeyboard;

/**
 * The completion block that will be invoked after -registerRemoteNotifications.
 */
@property (nullable, nonatomic, copy) void (^registerRemoteNotificationsCompletion)(NSData * _Nullable deviceToken, NSError * _Nullable error);

/**
 * Register to receive remote notifications via Apple Push Notification service.
 */
- (void)registerForRemoteNotificationsWithCompletion:(void (^ _Nullable)(NSData * _Nullable deviceToken, NSError * _Nullable error))completion;

/**
 * Simulate low memory warning, just for testing.
 *
 * @warning Don't use this method in production because it uses private API.
 */
- (void)simulateMemoryWarning;

/**
 * Checks whether the current device can make phone calls.
 */
- (BOOL)canMakePhoneCalls;

/**
 * Make a phone call to the phone number.
 * @node Call the `-canMakePhoneCalls` method before making phone calls.
 */
- (void)makePhoneCall:(NSString *)phoneNumber;

@end

@interface UIApplication (ESAppInfo)

/**
 * The app name.
 * @discussion The default value is the executable in the main bundle.
 */
@property (null_resettable, nonatomic, copy) NSString *appName;

/**
 * The channel that app submitted to.
 * @discussion The default value is "App Store".
 */
@property (null_resettable, nonatomic, copy) NSString *appChannel;

/**
 * The app ID in the App Store.
 */
@property (nullable, nonatomic, copy) NSString *appStoreID;

@property (nonatomic, readonly) NSString *appBundleName;
@property (nonatomic, readonly) NSString *appDisplayName;
@property (nonatomic, readonly) NSString *appBundleIdentifier;
@property (nonatomic, readonly) NSString *appVersion;
@property (nonatomic, readonly) NSString *appBuildVersion;
@property (nonatomic, readonly) NSString *appFullVersion; // "1.2.4 (210)"
@property (nonatomic, readonly) BOOL isUIViewControllerBasedStatusBarAppearance;

/// The first filename in the CFBundleIconFiles
@property (nullable, nonatomic, readonly) NSString *appIconFile;

- (nullable UIImage *)appIconImage;

/**
 * Returns the date when the app was launched.
 */
@property (nonatomic, readonly) NSDate *appStartupDate;

/**
 * Returns the duration of the app has been running.
 */
@property (nonatomic, readonly) NSTimeInterval appUptime;

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
 * Returns all URL schemes (http, ftp, and so on) supported by the app.
 * @discussion All URL Types specified in the Info.plist file.
 */
- (NSSet *)allURLSchemes;

/**
 * Returns all URL schemes that identified by the given identifier.
 */
- (NSSet *)URLSchemesForIdentifier:(nullable NSString *)identifier;

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
 *     "app_channel" : "App Store",
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

/**
 * Returns the user agent for HTTP requests.
 * @code
 * // Example:
 * "ExampleApp/1.3 (iPhone; iOS 12.2; Channel/dev; Scale/3.00; Screen/414x736; Locale/zh_CN; Network/WiFi)"
 *
 * // Set user agent for HTTP request:
 * [request setValue:UIApplication.sharedApplication.userAgentForHTTPRequest forHTTPHeaderField:@"User-Agent"];
 *
 * // Set user agent for WKWebView configuration:
 * webViewConfiguration.applicationNameForUserAgent = UIApplication.sharedApplication.userAgentForHTTPRequest;
 * @endcode
 */
- (NSString *)userAgentForHTTPRequest;

@end

NS_ASSUME_NONNULL_END
