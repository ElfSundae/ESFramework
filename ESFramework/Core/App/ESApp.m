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

@implementation ESApp

+ (void)load
{
        @autoreleasepool {
                [self isFreshLaunch:nil];
        }
}

+ (instancetype)sharedApp
{
        static id __sharedApp = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                if ([[UIApplication sharedApplication].delegate isKindOfClass:[self class]]) {
                        __sharedApp = [UIApplication sharedApplication].delegate;
                } else {
                        __sharedApp = [[self alloc] init];
                }
        });
        return __sharedApp;
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
        
        /* Setup root viewController */
        //self.rootViewController = [self _setupRootViewController];
        //self.window.rootViewController = self.rootViewController;
        
        /* Set the UserAgent for UIWebView */
        NSString *ua = self.userAgentForWebView;
        if (ua) {
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua}];
        }
        
        /* Set Cookie Accept Plicy to  NSHTTPCookieAcceptPolicyAlways */
        //[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        
        /* Enable multitasking */
        [[self class] enableMultitasking];

        /* Process launch options */
        if (launchOptions) {
                self.remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        }
        
        //[self _applicationDidFinishLaunching:application withOptions:launchOptions];
        
        //[self.window makeKeyAndVisible];
        return YES;
}

// iOS8+
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
        if (notificationSettings == UIUserNotificationTypeNone) {
                // failed
                NSError *error = [NSError errorWithDomain:ESAppErrorDomain code:-11 userInfo:@{NSLocalizedDescriptionKey : @"Can not register user notification settings."}];
                [self application:application didFailToRegisterForRemoteNotificationsWithError:error];
        } else {
                [application registerForRemoteNotifications];
        }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        NSString *token = [deviceToken description];
        token = [token stringByDeletingCharactersInString:@"<> "];
        if (_esRemoteNotificationRegisterSuccessBlock) {
                _esRemoteNotificationRegisterSuccessBlock(token);
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
        self.remoteNotification = userInfo;
        [self applicationDidReceiveRemoteNotification:self.remoteNotification];
}

- (void)_es_UIApplicationDidBecomeActiveNotificationHandler:(NSNotification *)notification
{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                if (ESIsDictionaryWithItems(self.remoteNotification)) {
                        [self applicationDidReceiveRemoteNotification:self.remoteNotification];
                }
        });
}

@end
