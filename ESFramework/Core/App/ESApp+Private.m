//
//  ESApp+Private.m
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"

@implementation ESApp (Private)

- (void)_es_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)remoteNotification fromAppLaunch:(BOOL)fromLaunch
{
        if ([application.delegate conformsToProtocol:@protocol(ESAppDelegate)] &&
            [(id<ESAppDelegate>)application.delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fromAppLaunch:)]) {
                [(id<ESAppDelegate>)application.delegate application:application didReceiveRemoteNotification:remoteNotification fromAppLaunch:fromLaunch];
        }
        
        NSDictionary *notificationUserInfo = @{(fromLaunch ? UIApplicationLaunchOptionsRemoteNotificationKey : ESAppRemoteNotificationKey): remoteNotification};
        [[NSNotificationCenter defaultCenter] postNotificationName:ESAppDidReceiveRemoteNotificationNotification object:application userInfo:notificationUserInfo];
}

+ (void)_es_applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification
{
        // Initilization
        [ESApp sharedApp]->_esBackgroundTaskIdentifier = UIBackgroundTaskInvalid;
        if (notification.userInfo) {
                [ESApp sharedApp]->_esRemoteNotificationFromLaunch = notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey];
        }
        
        // Hack AppDelegate for UINotifications methods
        __ESAppHackAppDelegateUINotificationsMethods();
        
        // Fetch the default user agent of UIWebView
        [ESApp _es_getDefaultWebViewUserAgent];
        
        // Enable app background multitasking
        [self enableMultitasking];
}

+ (void)_es_applicationDidBecomeActiveNotificationHandler:(NSNotification *)notification
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                // callback remote notification handler
                if ([ESApp sharedApp]->_esRemoteNotificationFromLaunch) {
                        [[ESApp sharedApp] _es_application:notification.object didReceiveRemoteNotification:[ESApp sharedApp]->_esRemoteNotificationFromLaunch fromAppLaunch:YES];
                        [ESApp sharedApp]->_esRemoteNotificationFromLaunch = nil;
                }
        });
}

@end
