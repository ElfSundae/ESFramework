//
//  ESApp.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

/**
 * Posts when received remote notifications.
 * Keys for userInfo: UIApplicationLaunchOptionsRemoteNotificationKey or ESAppRemoteNotificationKey
 */
FOUNDATION_EXTERN NSString *const ESAppDidReceiveRemoteNotificationNotification;
FOUNDATION_EXTERN NSString *const ESAppRemoteNotificationKey;

FOUNDATION_EXTERN NSString *const ESAppErrorDomain;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESAppDelegate

@protocol ESAppDelegate <NSObject>
@optional

/**
 * Invoked when `-application:didReceiveRemoteNotification:` and the first applicationDidBecomeActive if there is an APNS object in UIApplicationLaunchOptionsRemoteNotificationKey.
 *
 * If your app delegate is not a subclass of ESApp, you can also implement this delegate method to receive remote notifications.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)remoteNotification fromAppLaunch:(BOOL)fromLaunch;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp

/**
 * `ESApp` is designed as the delegate of UIApplication, it can also be used as a global helper class.
 */
@interface ESApp : UIResponder <UIApplicationDelegate, ESAppDelegate>

/**
 * Returns the shared ESApp instance.
 */
+ (instancetype)sharedApp;

/**
 * Returns the keyWindow of app.
 */
@property (nonatomic, strong) UIWindow *window;

/**
 * Returns the root view controller of keyWindow.
 *
 * If your app delegate is a subclass of ESApp, you can overwrite this property and @dynamic it to
 * specify a different class instead `UIViewController`.
 */
@property (nonatomic, strong) UIViewController *rootViewController;

/**
 * UIApplicationDelegate implementation.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AppInfo

@interface ESApp (_AppInfo)

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
#pragma mark - Notifications

@interface ESApp (_Notifications)
/**
 * @note success可能会延迟回调。例如：用户在系统设置里关闭了app的通知，调用register时会回调failure,
 * 如果用户在app运行期间去系统设置里打开了app的push通知，此时会回调success。
 *
 * `categories` is only for iOS8+, contains instances of UIUserNotificationCategory or UNNotificationCategory (iOS10+).
 */
- (void)registerForRemoteNotificationsWithTypes:(UIUserNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure;
- (void)setCallbackForRemoteNotificationsRegistrationWithSuccess:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success failure:(void (^)(NSError *error))failure;
- (void)unregisterForRemoteNotifications;
- (BOOL)isRegisteredForRemoteNotifications;
- (UIUserNotificationType)enabledRemoteNotificationTypes;
- (NSString *)remoteNotificationsDeviceToken;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper

@interface ESApp (_Helper)

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
 * @note this method is synchronously, that means if you provide a remote URL for `plistURL`, you may
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

/// =============================================
/// @name UI
/// =============================================

+ (UIWindow *)keyWindow;
- (UIWindow *)keyWindow;

+ (void)dismissKeyboard;

/**
 * Returns the root view controller of keyWindow.
 */
+ (UIViewController *)rootViewController;

/**
 * Returns the root view controller for presenting modal view controller.
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

/**
 * Checks if the application state is UIApplicationStateActive
 */
+ (BOOL)isInForeground;

/**
 * Sets `applicationIconBadgeNumber` to zero.
 */
+ (void)clearApplicationIconBadgeNumber;

/// =============================================
/// @name Open URL
/// =============================================

/**
 * Checks whether the current device can make a phone call.
 */
+ (BOOL)canOpenPhoneCall;

/**
 * Makes a phone call to the given phone number.
 * If `shouldReturn` is YES, it will return back to this app after phone call.
 */
+ (BOOL)openPhoneCall:(NSString *)phoneNumber returnToAppAfterCall:(BOOL)shouldReturn;

@end
