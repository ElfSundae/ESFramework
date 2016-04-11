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
FOUNDATION_EXTERN BOOL __ESCheckAppFreshLaunch(NSString *__autoreleasing *previousAppVersion);

/**
 * Returns the default user agent of UIWebView.
 */
FOUNDATION_EXTERN NSString *__ESWebViewDefaultUserAgent(void);

/**
 * Notify received remote notification via ESAppDidReceiveRemoteNotificationNotification.
 */
FOUNDATION_EXTERN void __ESApplicationDidReceiveRemoteNotification(UIApplication *application, NSDictionary *remoteNotification, BOOL fromAppLaunch);

@interface ESApp ()
{
        void (^__esRemoteNotificationRegisterSuccessBlock)(NSData *deviceToken, NSString *deviceTokenString);
        void (^__esRemoteNotificationRegisterFailureBlock)(NSError *error);
        NSString *__esRemoteNotificationsDeviceToken;
}

@end

@interface ESApp (__Internal)
- (BOOL)_es_application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
@end

@interface ESApp (_UINotificationsPrivate)
- (void)_es_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
- (void)_es_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)_es_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)_es_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end

/**
 * Handler for receiving NSNotifications.
 */
@interface __ESAppNotificationsHandler : NSObject
+ (void)applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification;
+ (void)applicationDidBecomeActiveNotificationHandler:(NSNotification *)notification;
@end
