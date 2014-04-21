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
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.f];
        [self.window makeKeyAndVisible];
        
        [self setupRootViewController];
        self.window.rootViewController = self.rootViewController;
        
        ES_WEAK_VAR(self, _self);
        ESDispatchAsyncOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_DEFAULT, ^{
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : [[self class] userAgent]}];
                [[_self class] enableMultitasking];
                
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

- (void)applicationDidEnterBackground:(UIApplication *)application;
{
        [self clearApplicationIconBadgeNumber];
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
        [self applicationDidReceiveRemoteNotification:userInfo];
}

@end
