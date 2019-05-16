//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "_ESApp_Private.h"

NSString *const ESAppErrorDomain = @"ESAppErrorDomain";

static ESApp *__gSharedApp = nil;
static NSDictionary *__gRemoteNotificationFromLaunch = nil;

@implementation ESApp

- (void)_es_applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification
{
    __gRemoteNotificationFromLaunch = notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey];
}

- (void)_es_applicationDidBecomeActiveNotificationHandler:(NSNotification *)notification
{
    if (__gRemoteNotificationFromLaunch) {
        es_didReceiveRemoteNotification(__gRemoteNotificationFromLaunch, YES);
        __gRemoteNotificationFromLaunch = nil;
    }
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplication (_ESAppHacking)

@interface UIApplication (_ESAppHacking)
@end

@implementation UIApplication (_ESAppHacking)

+ (void)load
{
    ESSwizzleInstanceMethod(self, @selector(setDelegate:), @selector(_ESAppHacking_setDelegate:));
}

- (void)_ESAppHacking_setDelegate:(id<UIApplicationDelegate>)delegate
{
    [self _ESAppHacking_setDelegate:delegate];

    if ([delegate isKindOfClass:[ESApp class]]) {
        __gSharedApp = (ESApp *)delegate;
    } else {
        __gSharedApp = [[ESApp alloc] init];
    }

    es_hackAppDelegateForNotifications(delegate);

    [[NSNotificationCenter defaultCenter] addObserver:__gSharedApp selector:@selector(_es_applicationDidFinishLaunchingNotificationHandler:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:__gSharedApp selector:@selector(_es_applicationDidBecomeActiveNotificationHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
