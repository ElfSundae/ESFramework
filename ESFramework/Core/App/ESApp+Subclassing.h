//
//  ESApp+Subclassing.h
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@interface ESApp (Subclassing)

/**
 * Setup your rootViewController for keyWindow.
 * You can overwrite property `rootViewController` and @dynamic in your appDelegate implementation file.
 */
//- (UIViewController *)_setupRootViewController;

/**
 * Invoked within `-application:didFinishLaunchingWithOptions:`.
 */
//- (void)_applicationDidFinishLaunching:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;

/**
 * Invoked within `-application:didReceiveRemoteNotification:`.
 * The `self.remoteNotification` has been fill.
 */
- (void)_applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 * @"App Store" as default.
 */
- (NSString *)appChannel;
/**
 * App ID in App Store, used to generate App Store Download link and the review link.
 *
 * @see +openAppStore +openAppReviewPage
 */
- (NSString *)appID;
/**
 * Returns the timeZone used by your web server, used to convert datetime from server to local.
 *
 * Default is `[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]`
 */
- (NSTimeZone *)serverTimeZone;

#if 0 // Deprecated
/**
 * Your App Update datasource.
 */
- (ESAppUpdateObject *)appUpdateSharedObject;
/**
 * You can subclass this method to give a global handler, such as ***resetUser*** or ***cleanCaches*** inside handler,
 * do remember call `openURL` if `handler` return `NO`.
 */
- (void)showAppUpdateAlert:(ESAppUpdateObject *)updateObject alertMask:(ESAppUpdateAlertMask)alertMask;
#endif

@end
