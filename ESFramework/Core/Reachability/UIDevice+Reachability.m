//
//  UIDevice+Reachability.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-12.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIDevice+Reachability.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
NSString *const UIDeviceNetworkReachabilityChangedNotification = @"UIDeviceNetworkReachabilityChangedNotification";
NSString *const UIDeviceNetworkStatusNotReachable = @"None";
NSString *const UIDeviceNetworkStatusReachableViaWWAN = @"WWAN";
NSString *const UIDeviceNetworkStatusReachableViaWiFi = @"WiFi";

static Reachability *__sharedReachability = nil;
static BOOL __sharedHasStartedNotifier = NO;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject+_ESUIDeviceReachabilityInternal

@interface NSObject (_ESUIDeviceNetworkReachabilityInternal)
@property (nonatomic, copy) ESUIDeviceNetworkReachabilityChangedHandler __es_reachabilityChangedHanlder;
@end

static const void *__es_reachabilityChangedHanlderKey = &__es_reachabilityChangedHanlderKey;

@implementation NSObject (_ESUIDeviceNetworkReachabilityInternal)
- (ESUIDeviceNetworkReachabilityChangedHandler)__es_reachabilityChangedHanlder
{
        return [self getAssociatedObject:__es_reachabilityChangedHanlderKey];
}
- (void)set__es_reachabilityChangedHanlder:(ESUIDeviceNetworkReachabilityChangedHandler)handler
{
        [self setAssociatedObject_nonatomic_copy:handler key:__es_reachabilityChangedHanlderKey];
}

- (void)__es_deviceReachabilityChangedNotificationHandler:(NSNotification *)notification
{
        Reachability *ability = notification.object;
        if ([ability isKindOfClass:[Reachability class]] &&
            [ability isEqual:__sharedReachability] &&
            self.__es_reachabilityChangedHanlder) {
                self.__es_reachabilityChangedHanlder(__sharedReachability, __sharedReachability.currentReachabilityStatus);
        }
}

- (void)setNetworkReachabilityChangedHandler:(ESUIDeviceNetworkReachabilityChangedHandler)handler
{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceNetworkReachabilityChangedNotification object:__sharedReachability];
        self.__es_reachabilityChangedHanlder = nil;

        if (handler) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(__es_deviceReachabilityChangedNotificationHandler:) name:UIDeviceNetworkReachabilityChangedNotification object:__sharedReachability];
                self.__es_reachabilityChangedHanlder = handler;
        }
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation UIDevice (Reachability)

+ (void)load
{
        @autoreleasepool {
                __sharedReachability = [Reachability reachabilityForInternetConnection];
                [self startNetworkNotifier];
        }
}


+ (NetworkStatus)currentNetworkStatus
{
        return __sharedReachability.currentReachabilityStatus;
}

+ (NSString *)currentNetworkStatusString
{
        NetworkStatus status = [self currentNetworkStatus];
        NSString *result = UIDeviceNetworkStatusNotReachable;
        if (kReachableViaWiFi == status) {
                result = UIDeviceNetworkStatusReachableViaWiFi;
        } else if (kReachableViaWWAN == status) {
                result = UIDeviceNetworkStatusReachableViaWWAN;
        }
        return result;
}

+ (BOOL)startNetworkNotifier
{
        if (__sharedHasStartedNotifier) {
                return YES;
        }
        __sharedHasStartedNotifier = [__sharedReachability startNotifier];
        return __sharedHasStartedNotifier;
}

+ (void)stopNetworkNotifier
{
        [__sharedReachability stopNotifier];
}

+ (BOOL)hasStartedNetworkNotifier
{
        return __sharedHasStartedNotifier;
}

@end
