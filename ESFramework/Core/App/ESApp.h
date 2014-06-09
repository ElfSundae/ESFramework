//
//  ESApp.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ESDefines.h"
#import "ESAppUpdateObject.h"

/**
 * App helper class, and you can subclass it as your app delegate.
 *
 * `AFNetworkActivityIndicatorManager` has been enabled if it exists.
 *
 * ## Subclassing Notes
 *
 *
 * 	// Call super, do special initiations, then return YES.
 * 	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 * 	{
 * 	        [super application:application didFinishLaunchingWithOptions:launchOptions];
 * 	        self.window.backgroundColor = [UIColor whiteColor];
 * 	        return YES;
 * 	}
 *
 * 	- (void)_setupRootViewController
 * 	{
 * 	        self.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
 * 	}
 *
 * 	// handle `openURL`
 * 	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
 * 		return YES;
 * 	}
 *
 * 	// in someone method:
 * 	{
 * 		// Register remote notification
 * 		[[AppDelegate sharedApp] registerRemoteNotificationWithHandler:^(id sender) {
 * 		        NSLog(@"%@", sender);
 * 		}];
 * 	}
 *
 * 	// Invoked after receiving remote notification
 * 	- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo {
 * 	        [[self class] clearApplicationIconBadgeNumber];
 * 	}
 *
 * 	- (void)applicationDidEnterBackground:(UIApplication *)application {
 * 	        [[self class] clearApplicationIconBadgeNumber];
 * 	}
 *
 * 	// Returns the current app channel, e.g. @"App Store"
 * 	- (NSString *)appChannel
 * 	{
 * 	        return @"App Store";
 * 	}
 *	
 * 	- (NSString *)appID
 * 	{
 * 	        return @"11111111";
 * 	}
 * 	- (NSTimeZone *)serverTimeZone
 * 	{
 * 	        return [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
 * 	}
 *      
 *
 * ### Remote notification Payload
 *
 * 	{
 * 	    aps =     {
 * 	        alert = "kfang (Enterprise)";
 * 	        badge = 30;
 * 	        sound = default;
 * 	    };
 * 	    custom =     {
 * 	        key = value;
 * 	    };
 * 	    foo = bar;
 * 	}
 *
 */
@interface ESApp : UIResponder
__ES_ATTRIBUTE_UNAVAILABLE_SINGLETON_ALLOCATION

/**
 * Returns the application delegate if the `AppDelegate` is a subclass of `ESApp`, 
 * otherwise returns a shared `ESApp` instance.
 */
+ (instancetype)sharedApp;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) NSDictionary *remoteNotification;
@property (nonatomic, copy) NSString *remoteNotificationsDeviceToken;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Subclassing

@interface ESApp (Subclassing)
- (void)_setupRootViewController;
/**
 * @"App Store" as default.
 */
- (NSString *)appChannel;
/** 
 * App ID in App Store. 
 */
- (NSString *)appID;
/**
 * TimeZone from server (e.g. HTTP server).
 *
 * Default is `[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]`
 */
- (NSTimeZone *)serverTimeZone;

/**
 * Your App Update data source.
 */
- (ESAppUpdateObject *)appUpdateSharedObject;
/**
 * You can subclass this method to give a global handler, such as ***resetUser*** or ***cleanCaches*** inside handler,
 * do remember call `openURL` if `handler` return `NO`.
 */
- (void)showAppUpdateAlert:(ESAppUpdateObject *)updateObject alertMask:(ESAppUpdateAlertMask)alertMask;

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (AppInfo)

@interface ESApp (AppInfo)
+ (NSBundle *)mainBundle;
+ (NSDictionary *)infoDictionary;
+ (id)objectForInfoDictionaryKey:(NSString *)key;
+ (NSString *)displayName;
+ (NSString *)appVersion;
+ (BOOL)isUIViewControllerBasedStatusBarAppearance;
+ (NSString *)bundleIdentifier;


- (NSMutableDictionary *)analyticsInformation;
/**
 * Returns User Agent for UIWebView.
 *
 * Default User Agent for UIWebView, it registered after app launched.
 * Subclass can return #nil to use the default user-agent for UIWebView.
 *
 * e.g. `Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_1 like Mac OS X) Mobile/11D201 ES(iOS;7.1.1;com.0x123.ESDemo;1.0.0;App Store;6ec547beea181d3fca2b0aa770353a0706f7fb3f;640x960;zh_CN)`
 */
- (NSString *)userAgentForWebView;

/**
 * Returns User Agent for HTTP request.
 *
 * @see -[NSMutableURLRequest(ESUserAgent) addUserAgent]
 *
 * e.g. `ES(iOS;7.1.1;com.0x123.ESDemo;1.0.0;App Store;6ec547beea181d3fca2b0aa770353a0706f7fb3f;640x960;zh_CN)`
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (ApplicationDelegate)
@interface ESApp (ApplicationDelegate) <UIApplicationDelegate>

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (UI)
@interface ESApp (UI)

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

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (Helper)
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
 * Don't use this in production because it uses private API.
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
 * Open App Store, and goto this app's download page.
 */
+ (void)openAppStore;
+ (void)openAppStoreWithAppID:(NSString *)appID;

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

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (Notification)

@interface ESApp (Notification)
/**
 * If register succueed, handler's `sender` will be the device token (NSString type without blank chars.),
 * or else `sender` will be a NSError object.
 */
- (void)registerRemoteNotificationWithHandler:(ESHandlerBlock)handler;
- (void)registerRemoteNotificationTypes:(UIRemoteNotificationType)types handler:(ESHandlerBlock)hander;

@end
