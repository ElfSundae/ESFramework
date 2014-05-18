//
//  ESApp+Subclassing.m
//  ESFramework
//
//  Created by Elf Sundae on 5/18/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+ESInternal.h"

@implementation ESApp (Subclassing)

- (void)setupRootViewController
{
        self.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
}

- (NSString *)appChannel
{
        return @"App Store";
}

- (NSString *)appID
{
        return nil;
}

- (NSTimeZone *)serverTimeZone
{
        return [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
}

- (ESAppUpdateObject *)appUpdateSharedObject
{
        return [ESAppUpdateObject sharedObject];
}

- (void)showAppUpdateAlert:(ESAppUpdateObject *)updateObject alertMask:(ESAppUpdateAlertMask)alertMask
{
        [self showAppUpdateAlert:updateObject alertMask:alertMask handler:nil];
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
        NSLogInfo(@"remote notification:\n%@", userInfo);
}

@end
