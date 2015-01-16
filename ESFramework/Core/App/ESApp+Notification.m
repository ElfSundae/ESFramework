//
//  ESApp+Notification.m
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+Internal.h"

@implementation ESApp (Notification)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Remote Notification

- (void)registerRemoteNotificationTypes:(UIRemoteNotificationType)types success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
        if (![self.class _isUIApplicationDelegate]) {
                [NSException raise:@"ESAppIsNotApplicationDelegateException" format:@"To use this method, the application delegate must be inherited from ESApp."];
        }
        
        _remoteNotificationRegisterSuccessBlock = success;
        _remoteNotificationRegisterFailureBlock = failure;
        
        
        
}

- (void)registerRemoteNotificationTypes:(UIRemoteNotificationType)types handler:(ESHandlerBlock)hander
{
        if (![[self class] _isUIApplicationDelegate]) {
                [NSException raise:@"ESAppIsNotApplicationDelegateException" format:@"To use this method, the application delegate must be inherited from ESApp."];
        }
//        self._remoteNotificationRegisterResultHandler = hander;

        //TODO: 管理remoteNotification和localNotification, 提供 注册,查询,注销等方法.
        // 兼容iOS8
        
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                [app registerUserNotificationSettings:
                 [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert |
                                                               UIUserNotificationTypeBadge |
                                                               UIUserNotificationTypeSound)
                                                   categories:nil]];
                [app registerForRemoteNotifications];
        } else {
                [app registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeSound)];
                
        }
}

- (void)registerRemoteNotificationWithHandler:(ESHandlerBlock)handler
{
        [self registerRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) handler:handler];
}

@end
