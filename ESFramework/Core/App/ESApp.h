//
//  ESApp.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"

ES_EXTERN NSString *const ESAppErrorDomain;
typedef NS_ENUM(NSInteger, ESAppErrorCode) {
        
        ESAppErrorCodeRemoteNotificationTypesIsNone             = -10,
        // for iOS8+ only
        ESAppErrorCodeCouldNotRegisterUserNotificationSettings  = -11,
};

/// The key for NSUserDefaults that stores app version string for checking fresh launch.
ES_EXTERN NSString *const ESAppCheckFreshLaunchUserDefaultsKey;

/// Posted when received remote notification on app launch or within -application:didReceiveRemoteNotification:
ES_EXTERN NSString *const ESAppDidReceiveRemoteNotificationNotification;
/// Key of userInfo for ESAppDidReceiveRemoteNotificationNotification
ES_EXTERN NSString *const ESAppRemoteNotificationKey;

/*!
 * `ESApp` is designed as the delegate of UIApplication, also it can be used
 * as a global helper class.
 *
 * If your application delegate is a subclass of `ESApp`, the `-application:didFinishLaunchingWithOptions:` defines
 * in `<UIApplicationDelegate>` has been implemented.
 * And ESApp has done the following things:
 *
 *      + Setup window
 *      + Enable multitasking, see +enableMultitasking;
 *
 */
@interface ESApp : UIResponder <UIApplicationDelegate>

/**
 * Returns the application delegate if the `AppDelegate` is a subclass of `ESApp`, 
 * otherwise returns a shared `ESApp` instance.
 */
+ (instancetype)sharedApp;

@property (nonatomic, strong) UIWindow *window;

/**
 * You can overwrite property `rootViewController` and @dynamic it 
 * in your app delegate implementation file, to specify a different type instead
 * `UIViewController`.
 */
@property (nonatomic, strong) UIViewController *rootViewController;

/// @name UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/// @name Sigleton

+ (id)alloc __attribute__((unavailable("alloc not available, call sharedApp instead.")));
+ (id)new __attribute__((unavailable("new not available, call sharedApp instead.")));

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclassing

@interface ESApp (Subclassing)

/**
 * Returns the channel/store that app submitted, default is @"App Store".
 */
- (NSString *)appChannel;
/**
 * App ID in App Store, used to generate App Store Download link and the review link.
 *
 * @see +openAppStore +openAppReviewPage
 */
- (NSString *)appStoreID;
/**
 * Returns the timeZone used by your web/API server/backend, it used to convert datetime between server and local.
 * Default is "GMT"
 *
 * e.g. [NSTimeZone timeZoneWithName:@"Asia/Shanghai"]
 */
- (NSTimeZone *)appWebServerTimeZone;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AppInfo
@interface ESApp (AppInfo)

/**
 * Returns the value associated with the specified key in the main bundle's Info.plist file.
 */
+ (id)objectForInfoDictionaryKey:(NSString *)key;

/**
 * Returns the value of CFBundleIdentifier in the main bundle's Info.plist file.
 */
+ (NSString *)appBundleIdentifier;

/**
 * Returns the value of CFBundleShortVersionString in the main bundle's Info.plist file.
 * If the value is not found, it will return the value of CFBundleVersion or @"1.0"
 */
+ (NSString *)appVersion;

/**
 * CFBundleShortVersionString + CFBundleVersion
 * e.g. "1.2.1(20150433.387)", "1.2.0", "2015988"
 */
+ (NSString *)appVersionWithBuildVersion;

/**
 * UIViewControllerBasedStatusBarAppearance (Boolean - iOS) specifies whether the status bar appearance
 * is based on the style preferred by the view controller that is currently under the status bar.
 * When this key is not present or its value is set to YES, the view controller determines the
 * status bar style. When the key is set to NO, view controllers (or the app) must each set the
 * status bar style explicitly using the UIApplication object.
 *
 * This key is supported in iOS 7.0 and later.
 *
 * @see https://developer.apple.com/library/mac/documentation/General/Reference/InfoPlistKeyReference/Articles/iPhoneOSKeys.html#//apple_ref/doc/uid/TP40009252-SW29
 */
+ (BOOL)isUIViewControllerBasedStatusBarAppearance;

/**
 * Returns the value of CFBundleExecutable in the main bundle's Info.plist file.
 * If the value is not found, it will return the app process name.
 */
- (NSString *)appName;

/**
 * Returns the value of CFBundleDisplayName in the main bundle's Info.plist file.
 * If the value is not found, it will return the value of CFBundleName or @"".
 */
- (NSString *)appDisplayName;

/**
 * e.g.
 *
 * @code
 * {
 *     "app_name" = ESDemo;
 *     "app_channel" = "App Store";
 *     "app_identifier" = "com.0x123.ESDemo";
 *     "app_version" = "1.0.2";
 *     "app_previous_version" = "1.0.0";
 *     carrier = "China Mobile";
 *     jailbroken = 1;
 *     locale = "zh_CN";
 *     model = iPhone;
 *     name = "Elf Sundae's iPhone";
 *     network = WiFi;
 *     "open_udid" = cf7cff0aaeea94806e247bf4e47a8ff760e46047;
 *     os = iOS;
 *     "os_version" = "8.4";
 *     platform = "iPhone7,1";
 *     "screen_size" = 1242x2208;
 *     "timezone_gmt" = 8;
 * }
 * @endcode
 *
 */
- (NSDictionary *)analyticsInformation;

/**
 * Returns the User Agent for HTTP request.
 *
 * e.g. `ESDemo/1.0.0 (iPhone; iOS 8.4; Scale/3.00; Screen/1242x2208; Locale/zh_CN; Network/WiFi; Channel/App Store; OpenUDID/cf7cff0aaeea94806e247bf4e47a8ff760e46047)`
 */
- (NSString *)userAgent;

/**
 * The default user agent of UIWebview.
 * The value will be fetched on a background thread after app launched, and it will cost about 100~300ms time.
 *
 * e.g. `Mozilla/5.0 (iPhone; CPU iPhone OS 8_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12H143 ESDemo/1.0.0 (iPhone; iOS 8.4; Scale/3.00; Screen/1242x2208; Locale/zh_CN; Channel/App Store; OpenUDID/cf7cff0aaeea94806e247bf4e47a8ff760e46047)`
 */
+ (NSString *)defaultUserAgentOfWebView;

/**
 * Returns the User Agent for UIWebView.
 *
 * This User Agent for UIWebView, it registered via +[NSUserDefaults registerDefaults:]
 * after app launched.
 * Subclass can return nil to use the iOS default User Agent for UIWebView.
 *
 * e.g. `Mozilla/5.0 (iPhone; CPU iPhone OS 8_4 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12H143 ESDemo/1.0.0 (iPhone; iOS 8.4; Scale/3.00; Screen/1242x2208; Locale/zh_CN; Network/WiFi; Channel/App Store; OpenUDID/cf7cff0aaeea94806e247bf4e47a8ff760e46047)`
 */
- (NSString *)userAgentForWebView;

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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINotifications
@interface ESApp (UINotifications)
/**
 * Note: success可能会延迟回调。例如：用户在系统设置里关闭了app的通知，调用register时会回调failure(error with ESAppErrorCodeCouldNotRegisterUserNotificationSettings),
 * 如果用户在app运行期间去系统设置里打开了app的push通知，此时会回调success。
 *
 * @param categories is only for iOS8+, contains instances of UIUserNotificationCategory.
 */
- (void)registerForRemoteNotificationsWithTypes:(UIRemoteNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure;
- (void)setCallbackForRemoteNotificationsRegistrationWithSuccess:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success failure:(void (^)(NSError *error))failure;
- (void)unregisterForRemoteNotifications;
- (BOOL)isRegisteredForRemoteNotifications;
- (UIRemoteNotificationType)enabledRemoteNotificationTypes;
- (NSString *)remoteNotificationsDeviceToken;

/**
 * Invoked when `-application:didReceiveRemoteNotification:` and the first applicationDidBecomeActive if there is an APNS object.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fromAppLaunch:(BOOL)fromLaunch;

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper
@interface ESApp (Helper)

/**
 * Checks whether the current launch is a **fresh launch** which means that
 * this is the first time launched by user, after the app was installed or updated.
 *
 * @param previousAppVersion return the previous app version, it may be the same as the current app version if it's not a fresh launch.
 */
+ (BOOL)isFreshLaunch:(NSString **)previousAppVersion;

/**
 * Delete all cookies which send to the given URL.
 */
+ (void)deleteHTTPCookiesForURL:(NSURL *)URL;

/**
 * Delete all HTTP Cookies.
 */
+ (void)deleteAllHTTPCookies;

/**
 * Simulate low memory warning.
 *
 * @warning Don't use this in production because it uses private API.
 */
+ (void)simulateLowMemoryWarning;

/**
 * Enable multitasking.
 * App in background can continue running 10 mins on iOS6-, 3 mins on iOS7+.
 */
+ (void)enableMultitasking;
/**
 * Disable multitasking.
 */
+ (void)disableMultitasking;

+ (BOOL)isMultitaskingEnabled;

+ (UIBackgroundTaskIdentifier)backgroundTaskIdentifier;

/**
 * Preferences for iOS apps are displayed by the system-provided Settings app.
 *
 * This method returns the registered defaules, or the default value from Settings Plist File,
 * the plistFile is usually "Root.plist" within main bundle's "Settings.bundle". And this method
 * will recurs "Child Pane Element" referenced page.
 * When you got the defaults dictionary, you can register them by call `-[NSUserDefaults registerDefaults:]`
 * the `-registerDefaults:` will not overwrite extant values.
 *
 * Note: this method is synchronously, that means if you provide a remote URL for `plistURL`, you may
 * consider calling this method on a secondary thread.
 *
 * The registration domain is volatile.  It does not persist across launches.
 * **You must register your defaults at each launch**; otherwise you will get
 * (system) default values when accessing the values of preferences the
 * user (via the Settings app) or your app (via set*:forKey:) has not
 * modified.  Registering a set of default values ensures that your app
 * always has a known good set of values to operate on.
 *
 * @see https://developer.apple.com/library/ios/documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007005-SW1
 */
+ (NSDictionary *)loadPreferencesDefaultsFromSettingsPlistAtURL:(NSURL *)plistURL;

/**
 * Loads defaults from `rootPlistURL`, then registers them.
 */
+ (BOOL)registerPreferencesDefaultsWithDefaultValues:(NSDictionary *)defaultValues forRootSettingsPlistAtURL:(NSURL *)rootPlistURL;

/**
 * Loads and registers main bundle's "Settings.bundle/Root.plist"
 */
+ (BOOL)registerPreferencesDefaultsWithDefaultValuesForAppDefaultRootSettingsPlist:(NSDictionary *)defaultValues;

///=============================================
/// @name UI
///=============================================

+ (UIWindow *)keyWindow;
- (UIWindow *)keyWindow;

+ (void)dismissKeyboard;

/**
 * The rootViewController of the keyWindow.
 */
+ (UIViewController *)rootViewController;

/**
 * The real rootViewController for presenting modalViewController.
 */
+ (UIViewController *)rootViewControllerForPresenting;

/**
 * Presents a viewController.
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion;
/**
 * Dismiss all Modal ViewControllers.
 */
+ (void)dismissAllViewControllersAnimated:(BOOL)animated completion:(void (^)(void))completion;

+ (BOOL)isInForeground;

+ (void)clearApplicationIconBadgeNumber;

///=============================================
/// @name Open URL
///=============================================

+ (BOOL)canOpenURL:(NSURL *)url;

/**
 * After check +canOpenURL: , then openURL.
 */
+ (BOOL)openURL:(NSURL *)url;
+ (BOOL)openURLWithString:(NSString *)string;

/**
 * Checks whether current device can make a phone call.
 */
+ (BOOL)canOpenPhoneCall;
/**
 * Make a phone call to the given phone number.
 * If `shouldReturn` is YES, it will return back to this app after phone call.
 */
+ (BOOL)openPhoneCall:(NSString *)phoneNumber returnToAppAfterCall:(BOOL)shouldReturn;

/**
 * Open App Store, and goto this app's Review page. `-appStoreID` must be implemented.
 */
+ (void)openAppStoreReviewPage;

/**
 * Open App Store, and goto this app's download page. `-appStoreID` must be implemented.
 */
+ (void)openAppStore;

///=============================================
/// @name Authorization
///=============================================

/**
 * Request `AddressBook` authorization if needed. `completion` and `failure` will callback on the main thread.
 */
- (void)requestAddressBookAccessWithCompletion:(dispatch_block_t)completion failure:(dispatch_block_t)failure;

@end
