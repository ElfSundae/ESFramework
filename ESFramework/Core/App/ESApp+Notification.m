//
//  ESApp+Notification.m
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+ESInternal.h"

@implementation ESApp (Notification)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Remote Notification

- (void)registerRemoteNotificationTypes:(UIRemoteNotificationType)types handler:(ESHandlerBlock)hander
{
        if (![[self class] _isUIApplicationDelegate]) {
                [NSException raise:@"ESAppIsNotApplicationDelegateException" format:@"To use this method, the application delegate must be inherited from ESApp."];
        }
        self._remoteNotificationRegisterResultHandler = hander;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
}

- (void)registerRemoteNotificationWithHandler:(ESHandlerBlock)handler
{
        //TODO: iOS 8 BugFix
        [self registerRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound) handler:handler];
}

@end
