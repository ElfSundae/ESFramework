//
//  ESApp.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "ESDefines.h"

@interface ESApp : UIResponder
__ES_ATTRIBUTE_UNAVAILABLE_SINGLETON_ALLOCATION

/**
 * Returns the application delegate.
 */
+ (instancetype)sharedApp;

/*!
 * To access these vars, your AppDelegate must be inherited from ESApp
 */
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) NSDictionary *remoteNotification;
@property (nonatomic, copy) NSString *remoteNotificationsDeviceToken;
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - AppInfo
@interface ESApp (AppInfo)

+ (NSBundle *)mainBundle;
+ (NSDictionary *)infoDictionary;
+ (id)objectForInfoDictionaryKey:(NSString *)key;
+ (NSString *)displayName;
+ (NSString *)appVersion;
+ (BOOL)isUIViewControllerBasedStatusBarAppearance;
+ (NSString *)bundleIdentifier;
+ (NSString *)appChannel;

+ (NSMutableDictionary *)analyticsInformation;
/**
 * Returns User Agent for UIWebView.
 *
 * Default User Agent for UIWebView, it registered after app launched.
 * Subclass can return #nil to use the default user-agent for UIWebView.
 */
+ (NSString *)userAgentForWebView;

/**
 * Returns User Agent for HTTP request.
 */
+ (NSString *)userAgent;
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
 * from another app (like Safari, [[UIApplication sharedApplication] openURL:...])
 */
+ (NSString *)URLScheme;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ApplicationDelegate
@interface ESApp (ApplicationDelegate) <UIApplicationDelegate>

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI 
@interface ESApp (UI)

+ (UIWindow *)keyWindow;
- (UIWindow *)keyWindow;

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

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helper
@interface ESApp (Helper)

/**
 * Checks whether the current launch is a "fresh launch" which means that 
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
 * Don't use this in production because it uses private API
 */
+ (void)simulateLowMemoryWarning;

/**
 * Multitasking
 */
+ (void)enableMultitasking;
+ (void)disableMultitasking;

+ (BOOL)canOpenURL:(NSURL *)url;
+ (BOOL)openURL:(NSURL *)url;
+ (BOOL)openURLWithString:(NSString *)urlString;
/**
 * Checks whether current device can make a phone call.
 */
+ (BOOL)canOpenPhoneCall;
/**
 * Make a phone call to the given phone number.
 * If #returnToAppAfterCall is YES, it will return back to this app after phone call.
 */
+ (BOOL)openPhoneCall:(NSString *)phoneNumber returnToAppAfterCall:(BOOL)shouldReturn;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification

@interface ESApp (Notification)
/**
 * If register succueed, handler's #sender will be the device token (NSString type without blank chars.),
 * otherwise, #sender will be a NSError object.
 */
- (void)registerRemoteNotificationWithHandler:(ESHandlerBlock)handler;
- (void)registerRemoteNotificationTypes:(UIRemoteNotificationType)types handler:(ESHandlerBlock)hander;
/**
 * Should be subclassed
 */
- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclass
@interface ESApp (Subclass)

/**
 * self.rootViewController = ....;
 */
- (void)setupRootViewController;
/*!
 
 // Call super, do special initiations, then return YES.
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
 
 // Invoked after receiving remote notification
 - (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;

 // Returns the current app channel, e.g. @"App Store"
 + (NSString *)appChannel;
 */

@end

@interface NSMutableURLRequest (ESUserAgent)
- (void)addUserAgent;
@end