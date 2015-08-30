//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"
#import "ESApp+Private.h"
#import "NSString+ESAdditions.h"

NSString *const ESAppErrorDomain = @"ESAppErrorDomain";

@interface _ESAppInternalWebViewDelegate : NSObject  <UIWebViewDelegate>
@end

@implementation ESApp

+ (void)load
{
        @autoreleasepool {
                [self isFreshLaunch:nil];
        }
}

+ (instancetype)sharedApp
{
        static id __gSharedApp = nil;
        
        id appDelegate = [UIApplication sharedApplication].delegate;
        if ([appDelegate isKindOfClass:[self class]]) {
                if (__gSharedApp) {
                        __gSharedApp = nil;
                }
                return appDelegate;
        }
        
        if (!__gSharedApp) {
                __gSharedApp = [[self alloc] init];
        }
        return __gSharedApp;
}

- (UIWindow *)window
{
        return _window ?: [[self class] keyWindow];
}

- (UIViewController *)rootViewController
{
        return _rootViewController ?: [[self class] rootViewController];
}

- (instancetype)init
{
        self = [super init];
        if (self) {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_es_UIApplicationDidBecomeActiveNotificationHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
        }
        return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        /* Setup window */
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.f];
        
        /* Enable multitasking */
        [[self class] enableMultitasking];

        /* Process launch options */
        if (launchOptions) {
                _remoteNotificationFromLaunch = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        }
        
        return YES;
}

// iOS8+
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
        if (notificationSettings.types == UIUserNotificationTypeNone) {
                // failed
                NSError *error = [NSError errorWithDomain:ESAppErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Can not register user notification settings."}];
                [self application:application didFailToRegisterForRemoteNotificationsWithError:error];
        } else {
                [application registerForRemoteNotifications];
        }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        NSString *tokenString = [[deviceToken description] stringByDeletingCharactersInString:@"<> "];
        if (_esRemoteNotificationRegisterSuccessBlock) {
                _esRemoteNotificationRegisterSuccessBlock(deviceToken, tokenString);
                _esRemoteNotificationRegisterSuccessBlock = nil;
        }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
        if (_esRemoteNotificationRegisterFailureBlock) {
                _esRemoteNotificationRegisterFailureBlock(error);
                _esRemoteNotificationRegisterFailureBlock = nil;
        }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
        /*
         * {
         *     aps =     {
         *         alert = "kfang (Enterprise)";
         *         badge = 30;
         *         sound = default;
         *     };
         *     custom =     {
         *         key = value;
         *     };
         *     foo = bar;
         * }
         */
        [self applicationDidReceiveRemoteNotification:userInfo isFromAppLaunch:NO];
}

- (void)_es_UIApplicationDidBecomeActiveNotificationHandler:(NSNotification *)notification
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                // fetch the default user agent of UIWebView
                [ESApp _getDefaultWebViewUserAgent];

                // callback remote notification handler
                if (_remoteNotificationFromLaunch) {
                        [self applicationDidReceiveRemoteNotification:_remoteNotificationFromLaunch isFromAppLaunch:YES];
                        _remoteNotificationFromLaunch = nil;
                }
        });
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - WebView UserAgent

static UIWebView *_esWebViewForFetchingUserAgent = nil;
static _ESAppInternalWebViewDelegate *_esWebViewForFetchingUserAgentDelegate = nil;

+ (void)_getDefaultWebViewUserAgent
{
        if (_esWebViewForFetchingUserAgent != nil) {
                return;
        }
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        
        ESDispatchOnHighQueue(^{
                _ESAppInternalWebViewDelegate *delegate = [[_ESAppInternalWebViewDelegate alloc] init];
                webView.delegate = delegate;
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0x123.com"]]];
                _esWebViewForFetchingUserAgent = webView;
                _esWebViewForFetchingUserAgentDelegate = delegate;
        });
}

+ (void)_setDefaultWebViewUserAgent:(NSString *)userAgent
{
        if (ESIsStringWithAnyText(userAgent)) {
                [ESApp sharedApp]->_esWebViewDefaultUserAgent = userAgent;
        }
        
        _esWebViewForFetchingUserAgent.delegate = nil;
        [_esWebViewForFetchingUserAgent stopLoading];
        _esWebViewForFetchingUserAgent = nil;
        _esWebViewForFetchingUserAgentDelegate = nil;
}

@end


@implementation _ESAppInternalWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        [ESApp _setDefaultWebViewUserAgent:request.allHTTPHeaderFields[@"User-Agent"]];
        return NO;
}

@end