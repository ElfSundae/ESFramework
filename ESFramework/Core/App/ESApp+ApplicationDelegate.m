//
//  ESApp+ESApplicationDelegate.m
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+ESInternal.h"

@implementation ESApp (ApplicationDelegate)

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
        [self application:application didFinishLaunchingWithOptions:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        /* Setup window */
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.f];
        [self.window makeKeyAndVisible];
        
        /* Setup root viewController */
        [self setupRootViewController];
        self.window.rootViewController = self.rootViewController;
        
        ES_WEAK_VAR(self, _self);
        ESDispatchOnHighQueue(^{
                /* Set the UserAgent for UIWebView */
                NSString *ua = [[self class] userAgentForWebView];
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
                
                if (_self.remoteNotification) {
                        ESDispatchAsyncOnMainThread(^{
                                [_self applicationDidReceiveRemoteNotification:_self.remoteNotification];
                        });
                }
        });
        
        return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Remote Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        NSString *token = [deviceToken description];
        [token stringByReplacingOccurrencesOfString:@"[<>\\s]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, token.length)];
        if (self._remoteNotificationRegisterResultHandler) {
                self._remoteNotificationRegisterResultHandler(token);
        }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
        if (self._remoteNotificationRegisterResultHandler) {
                self._remoteNotificationRegisterResultHandler(error);
        }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
        self.remoteNotification = userInfo;
        [self applicationDidReceiveRemoteNotification:self.remoteNotification];
}

@end
