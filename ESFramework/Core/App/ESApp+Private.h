//
//  ESApp+Private.h
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@interface ESApp (_Private)
@end

/**
 * Returns the shared ESApp instance.
 */
FOUNDATION_EXTERN ESApp *_ESSharedApp(void);

/**
 * Returns the default user agent of UIWebView.
 */
FOUNDATION_EXTERN NSString *_ESWebViewDefaultUserAgent(void);

/**
 * Hack UIApplicationDelegate instance for swizzling notification methods.
 */
FOUNDATION_EXTERN void es_hackAppDelegateForNotifications(id<UIApplicationDelegate> delegate);

/**
 * Invoke ESAppDelegate's method and post notification.
 */
FOUNDATION_EXTERN void _ESDidReceiveRemoteNotification(UIApplication *application, NSDictionary *remoteNotification, BOOL fromLaunch);
