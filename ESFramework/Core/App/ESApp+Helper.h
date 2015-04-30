//
//  ESApp+Helper.h
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@interface ESApp (Helper)

/**
 * Checks whether the current launch is a **fresh launch** which means that
 * this is the first time launched by user, after the app was installed or updated.
 *
 * @param previousAppVersion return the previous app version, it may be the same as the current app version if it's not a fresh launch.
 */
+ (BOOL)isFreshLaunch:(NSString **)previousAppVersion;

/**
 * Clean all HTTP Cookies.
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
 * Loads defaults from `rootPlistURL`, and register them.
 */
+ (BOOL)registerPreferencesDefaultsWithDefaultValues:(NSDictionary *)defaultValues forRootSettingsPlistAtURL:(NSURL *)rootPlistURL;

/**
 * Loads and register main bundle's "Settings.bundle/Root.plist"
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
- (UIViewController *)rootViewControllerForPresenting;

/**
 * Presents a viewController.
 */
+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion;
/**
 * Dismiss all Modal ViewControllers.
 */
+ (void)dismissAllViewControllersAnimated: (BOOL)flag completion: (void (^)(void))completion;

+ (BOOL)isInForeground;
- (BOOL)isInForeground;

+ (void)clearApplicationIconBadgeNumber;

///=============================================
/// @name Open URL
///=============================================

+ (BOOL)canOpenURL:(NSURL *)url;
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
 * Open App Store, and goto this app's Review page. `-appID` must be implemented.
 */
+ (void)openAppReviewPage;
/**
 * Open App Store, and goto the Review page.
 */
+ (void)openAppReviewPageWithAppID:(NSString *)appID;

/**
 * Open App Store, and goto this app's download page. `-appID` must be implemented.
 */
+ (void)openAppStore;

+ (void)openAppStoreWithAppID:(NSString *)appID;

#if 0 // deprecated
///=============================================
/// @name App Update
///=============================================

/**
 * Shows an `UIAlertView` for app update, use `+openURL:` to open external App Store when "Update" button clicked.
 */
- (void)showAppUpdateAlert:(ESAppUpdateObject *)updateObject alertMask:(ESAppUpdateAlertMask)alertMask handler:(BOOL (^)(ESAppUpdateObject *updateObject_, BOOL alertCanceld))handler;

/**
 * Use `-appUpdateSharedObject`.
 */
- (void)showAppUpdateAlert:(ESAppUpdateAlertMask)alertMask;

/**
 * You may call this method when app launched.
 *
 * If it's not the first launching, and there's a forced update, then call `handler`, it `handler` is nil
 * or `handler` returns `YES`, it will `openURL:updateObject`
 *
 * If it's the first launching, or there's not a forced update, then `updateObject` will be passed `nil`,
 * cause the cache maybe incorrect.
 *
 * `appUpdateSharedObject` will be used to check.
 */
- (void)checkForcedAppUpdateExists:(BOOL (^)(ESAppUpdateObject *updateObject))handler;
#endif

///=============================================
/// @name Authorization
///=============================================

/**
 * Request `AddressBook` authorization if needed. `completion` and `failure` will callback on the main thread.
 */
- (void)requestAddressBookAccessWithCompletion:(ESBasicBlock)completion failure:(ESBasicBlock)failure;

@end
