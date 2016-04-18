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

static ESApp *__gSharedApp = nil;

ESApp *_ESSharedApp(void)
{
        return __gSharedApp;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - _ESAppFetchWebViewUserAgent

static UIWebView *__gWebViewForFetchingUserAgent = nil;
static NSString *__gWebViewDefaultUserAgent = nil;

NSString *_ESWebViewDefaultUserAgent(void)
{
        return __gWebViewDefaultUserAgent;
}

@interface _ESAppFetchWebViewUserAgent : NSObject <UIWebViewDelegate>
@end

@implementation _ESAppFetchWebViewUserAgent

+ (void)load
{
        [self fetchUserAgent];
}

+ (void)fetchUserAgent
{
        if (__gWebViewForFetchingUserAgent || __gWebViewDefaultUserAgent) {
                return;
        }
        __gWebViewForFetchingUserAgent = [[UIWebView alloc] initWithFrame:CGRectZero];
        __gWebViewForFetchingUserAgent.delegate = (id<UIWebViewDelegate>)self;
        [__gWebViewForFetchingUserAgent loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0x123.com"]]];
}

+ (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        __gWebViewDefaultUserAgent = ESStringValue(request.allHTTPHeaderFields[@"User-Agent"]);
        __gWebViewForFetchingUserAgent = nil;
        return NO;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (_Private)

static NSDictionary *__gRemoteNotificationFromLaunch = nil;

@implementation ESApp (_Private)

- (void)_es_applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification
{
        __gRemoteNotificationFromLaunch = notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey];
        [[self class] enableMultitasking];
}

- (void)_es_applicationDidBecomeActiveNotificationHandler:(NSNotification *)notification
{
#define DISPATCH_ONCE_BEGIN     static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
#define DISPATCH_ONCE_END       });
        
        DISPATCH_ONCE_BEGIN
        if (__gRemoteNotificationFromLaunch) {
                _ESDidReceiveRemoteNotification([UIApplication sharedApplication], __gRemoteNotificationFromLaunch, YES);
                __gRemoteNotificationFromLaunch = nil;
        }
        DISPATCH_ONCE_END
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
        
        _ESAppHackAppDelegateForUINotifications();
        
        [[NSNotificationCenter defaultCenter] addObserver:__gSharedApp selector:@selector(_es_applicationDidFinishLaunchingNotificationHandler:) name:UIApplicationDidFinishLaunchingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:__gSharedApp selector:@selector(_es_applicationDidBecomeActiveNotificationHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
