//
//  ESApp+Private.m
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"
#import "ESValue.h"
#import "NSUserDefaults+ESAdditions.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - __ESAppInternalWebViewDelegateForFetchingUserAgent

static UIWebView *__esInternalWebViewForFetchingUserAgent = nil;
static NSString *__esWebViewDefaultUserAgent = nil;

NSString *__ESWebViewDefaultUserAgent(void)
{
        return __esWebViewDefaultUserAgent;
}

@interface __ESAppInternalFetchWebViewUserAgent : NSObject <UIWebViewDelegate>
@end

@implementation __ESAppInternalFetchWebViewUserAgent

+ (void)fetchUserAgent
{
        if (__esInternalWebViewForFetchingUserAgent || __esWebViewDefaultUserAgent) {
                return;
        }
        __esInternalWebViewForFetchingUserAgent = [[UIWebView alloc] initWithFrame:CGRectZero];
        __esInternalWebViewForFetchingUserAgent.delegate = (id<UIWebViewDelegate>)self;
        [__esInternalWebViewForFetchingUserAgent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0x123.com"]]];
}

+ (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        __esWebViewDefaultUserAgent = ESStringValue(request.allHTTPHeaderFields[@"User-Agent"]);
        [webView stopLoading];
        __esInternalWebViewForFetchingUserAgent = nil;
        return NO;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - __ESAppNotificationsHandler

static NSDictionary *__esRemoteNotificationFromLaunch = nil;

/*!
 * Handler for receiving NSNotifications.
 */
@interface __ESAppNotificationsHandler : NSObject

+ (void)applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification;
+ (void)applicationDidBecomeActiveNotificationHandler:(NSNotification *)notification;

@end

@implementation __ESAppNotificationsHandler

+ (void)applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification
{
        // Hack AppDelegate for accessing UINotifications methods
        __ESAppHackAppDelegateUINotificationsMethods();

        // Get remote notification from app launch options
        __esRemoteNotificationFromLaunch = notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey];
        
        // Enable app background multitasking
        [ESApp enableMultitasking];
        
        // Fetch the default user agent of UIWebView
        [__ESAppInternalFetchWebViewUserAgent fetchUserAgent];

}

+ (void)applicationDidBecomeActiveNotificationHandler:(NSNotification *)notification
{
        static dispatch_once_t onceTokenDidBecomeActiveNotificationHandler;
        dispatch_once(&onceTokenDidBecomeActiveNotificationHandler, ^{
                if (__esRemoteNotificationFromLaunch) {
                        __ESApplicationDidReceiveRemoteNotification(notification.object, __esRemoteNotificationFromLaunch, YES);
                        __esRemoteNotificationFromLaunch = nil;
                }
        });
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (__Internal)

@interface ESApp (__Internal)
@end

@implementation ESApp (__Internal)

+ (void)load
{
        @autoreleasepool {
                __ESCheckAppFreshLaunch(NULL);
                
                [[NSNotificationCenter defaultCenter] addObserver:[__ESAppNotificationsHandler class] selector:@selector(applicationDidFinishLaunchingNotificationHandler:) name:UIApplicationDidFinishLaunchingNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:[__ESAppNotificationsHandler class] selector:@selector(applicationDidBecomeActiveNotificationHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
        }
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functions

NSString *const ESAppCheckFreshLaunchUserDefaultsKey = @"ESAppCheckFreshLaunchUserDefaultsKey";

BOOL __ESCheckAppFreshLaunch(NSString **previousAppVersion)
{
        static NSString *__gPreviousVersion = nil;
        static BOOL __gIsFreshLaunch = NO;
        
        static dispatch_once_t onceTokenCheckAppFreshLaunch;
        dispatch_once(&onceTokenCheckAppFreshLaunch, ^{
                __gPreviousVersion = ESStringValue([NSUserDefaults objectForKey:ESAppCheckFreshLaunchUserDefaultsKey]);
                ESIsStringWithAnyText(__gPreviousVersion) || (__gPreviousVersion = nil);
                NSString *currentVersion = [ESApp appVersion];
                
                if (__gPreviousVersion && [__gPreviousVersion isEqualToString:currentVersion]) {
                        __gIsFreshLaunch = NO;
                } else {
                        __gIsFreshLaunch = YES;
                        [NSUserDefaults setObjectAsynchrony:currentVersion forKey:ESAppCheckFreshLaunchUserDefaultsKey];
                }
        });
        
        if (previousAppVersion) {
                *previousAppVersion = [__gPreviousVersion copy];
        }
        return __gIsFreshLaunch;
}

