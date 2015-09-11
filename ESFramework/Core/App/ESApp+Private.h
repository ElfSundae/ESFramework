//
//  ESApp+Private.h
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

ES_EXTERN void __ESAppHackAppDelegateUINotificationsMethods(void);

@interface ESApp ()
{
@private
        NSString *_esWebViewDefaultUserAgent;
        UIBackgroundTaskIdentifier _esBackgroundTaskIdentifier;
        
        void (^_esRemoteNotificationRegisterSuccessBlock)(NSData *deviceToken, NSString *deviceTokenString);
        void (^_esRemoteNotificationRegisterFailureBlock)(NSError *error);
        NSString *_esRemoteNotificationsDeviceToken;
        NSDictionary *_esRemoteNotificationFromLaunch;
}

@end

@interface ESApp (Private)
- (void)_es_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)remoteNotification fromAppLaunch:(BOOL)fromLaunch;

/// @name Notifications
+ (void)_es_applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification;
+ (void)_es_applicationDidBecomeActiveNotificationHandler:(NSNotification *)notification;
@end

@interface ESApp (WebViewUserAgent)
+ (void)_es_getDefaultWebViewUserAgent;
+ (void)_es_setDefaultWebViewUserAgent:(NSString *)userAgent;
@end
