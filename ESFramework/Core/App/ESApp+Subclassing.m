//
//  ESApp+Subclassing.m
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

ES_IMPLEMENTATION_CATEGORY_FIX(ESApp, Subclassing)

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
        
}

- (NSString *)appChannel
{
        return @"App Store";
}

- (NSString *)appID
{
        return nil;
}

- (NSTimeZone *)timeZoneOfWebServer
{
        return [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
}

#if 0
- (ESAppUpdateObject *)appUpdateSharedObject
{
        return [ESAppUpdateObject sharedObject];
}

- (void)showAppUpdateAlert:(ESAppUpdateObject *)updateObject alertMask:(ESAppUpdateAlertMask)alertMask
{
        [self showAppUpdateAlert:updateObject alertMask:alertMask handler:nil];
}
#endif

@end
