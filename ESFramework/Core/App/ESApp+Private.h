//
//  ESApp+Private.h
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import <ESFramework/ESApp.h>

/**
 * Checks if the current app launch is a fresh launch.
 */
FOUNDATION_EXTERN BOOL __ESCheckAppFreshLaunch(NSString **previousAppVersion);

/**
 * Returns the default user agent of UIWebView.
 */
FOUNDATION_EXTERN NSString *__ESWebViewDefaultUserAgent(void);

/**
 * Hacks AppDelegate for accessing UINotifications methods.
 */
FOUNDATION_EXTERN void __ESAppHackAppDelegateUINotificationsMethods(void);

/**
 * Notify received remote notification via ESAppDidReceiveRemoteNotificationNotification.
 */
FOUNDATION_EXTERN void __ESApplicationDidReceiveRemoteNotification(UIApplication *application, NSDictionary *remoteNotification, BOOL fromAppLaunch);
