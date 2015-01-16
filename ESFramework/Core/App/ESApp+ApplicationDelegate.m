//
//  ESApp+ESApplicationDelegate.m
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+Internal.h"

@implementation ESApp (ApplicationDelegate)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        /* Setup window */
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.f];
        [self.window makeKeyAndVisible];
                
        /* Setup root viewController */
        self.rootViewController = [self _setupRootViewController];
        self.window.rootViewController = self.rootViewController;
        
        ESWeakSelf;
        ESDispatchOnHighQueue(^{
                ESStrongSelf;
                /* Set the UserAgent for UIWebView */
                NSString *ua = _self.userAgentForWebView;
                if (ua) {
                        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua}];
                }
                
                /* Set Cookie Accept Plicy */
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
                
                /* Enable multitasking */
                [[_self class] enableMultitasking];
                
                /* Process launch options */
                if (launchOptions) {
                        _self.remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
                }
                
#if 0 // 启动时的remoteNotification一般是在主界面展示出来后处理
                if (_self.remoteNotification) {
                        ESDispatchOnMainThreadAsynchronously(^{
                                [_self applicationDidReceiveRemoteNotification:_self.remoteNotification];
                        });
                }
#endif
        });
        
        return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Remote Notification

//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//        NSString *token = [deviceToken description];
//        token = [token stringByReplacingOccurrencesOfString:@"[<>\\s]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, token.length)];
//        if (self._remoteNotificationRegisterResultHandler) {
//                self._remoteNotificationRegisterResultHandler(token);
//        }
//}
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
//{
//        if (self._remoteNotificationRegisterResultHandler) {
//                self._remoteNotificationRegisterResultHandler(error);
//        }
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
        self.remoteNotification = userInfo;
        [self applicationDidReceiveRemoteNotification:self.remoteNotification];
}

@end
