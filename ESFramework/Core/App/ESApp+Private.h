//
//  ESApp+Private.h
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

/**
 * Returns the shared ESApp instance.
 */
FOUNDATION_EXTERN ESApp *_ESSharedApp(void);

/**
 * Returns the default user agent of UIWebView.
 */
FOUNDATION_EXTERN NSString *_ESWebViewDefaultUserAgent(void);

/**
 * Hack AppDelegate for UINotifications methods.
 */
FOUNDATION_EXTERN void _ESAppHackAppDelegateForUINotifications(void);

/**
 * Invoke ESAppDelegate's method and post notification.
 */
FOUNDATION_EXTERN void _ESDidReceiveRemoteNotification(UIApplication *application, NSDictionary *remoteNotification, BOOL fromLaunch);

@interface ESApp (_Private)
@end
