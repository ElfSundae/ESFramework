//
//  _ESApp_Private.h
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#ifndef ESAPP_PRIVATE_H
#define ESAPP_PRIVATE_H

#import "ESApp.h"

/**
 * Hack UIApplicationDelegate instance for swizzling notification methods.
 */
FOUNDATION_EXTERN void es_hackAppDelegateForNotifications(id<UIApplicationDelegate> delegate);

/**
 * Invoke ESAppDelegate's method and post ESAppDidReceiveRemoteNotificationNotification notification.
 */
FOUNDATION_EXTERN void es_didReceiveRemoteNotification(NSDictionary *remoteNotification, BOOL fromLaunch);

#endif
