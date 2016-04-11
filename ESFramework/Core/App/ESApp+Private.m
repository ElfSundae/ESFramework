//
//  ESApp+Private.m
//  ESFramework
//
//  Created by Elf Sundae on 15/9/12.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"
#import <ESFramework/ESValue.h>
#import "NSUserDefaults+ESAdditions.h"

static void __ESAppHackAppDelegateMethods(void);

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
#pragma mark - UIApplication Hacking

@interface UIApplication (__ESAppHacking)
@end

@implementation UIApplication (__ESAppHacking)
+ (void)load
{
        ESSwizzleInstanceMethod(self, @selector(setDelegate:), @selector(__esSetDelegate:));
}

- (void)__esSetDelegate:(id<UIApplicationDelegate>)delegate
{
        [self __esSetDelegate:delegate];
        
        __ESAppHackAppDelegateMethods();
        
        // Fetch the default user agent of UIWebView
        [__ESAppInternalFetchWebViewUserAgent fetchUserAgent];
        
        // Pre-request push token, for self.analyticsInformation
        if ([ESApp sharedApp].isRegisteredForRemoteNotifications) {
                [[ESApp sharedApp] registerForRemoteNotificationsWithTypes:[[ESApp sharedApp] enabledRemoteNotificationTypes] categories:nil success:nil failure:nil];
        }
}
@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - __ESAppNotificationsHandler

static NSDictionary *__esRemoteNotificationFromLaunch = nil;

@implementation __ESAppNotificationsHandler

+ (void)applicationDidFinishLaunchingNotificationHandler:(NSNotification *)notification
{
        // Get remote notification from app launch options
        __esRemoteNotificationFromLaunch = notification.userInfo[UIApplicationLaunchOptionsRemoteNotificationKey];
        
        // Enable app background multitasking
        [ESApp enableMultitasking];
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

@implementation ESApp (__Internal)

+ (void)load
{
        @autoreleasepool {
                __ESCheckAppFreshLaunch(NULL);
                
                [[NSNotificationCenter defaultCenter] addObserver:[__ESAppNotificationsHandler class] selector:@selector(applicationDidFinishLaunchingNotificationHandler:) name:UIApplicationDidFinishLaunchingNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:[__ESAppNotificationsHandler class] selector:@selector(applicationDidBecomeActiveNotificationHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
        }
}

- (BOOL)_es_application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        return YES;
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functions

NSString *const ESAppCheckFreshLaunchUserDefaultsKey = @"ESAppCheckFreshLaunch";

BOOL __ESCheckAppFreshLaunch(NSString *__autoreleasing *previousAppVersion)
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


/**
 * 记录原始的实现方法（其实是交换后的 _es_... 方法，在交换后的方法里调用“本身”会调用到原始方法），如果有则说明是交换过的，需要调用交换前的方法。
 */
static SEL __gESOldMethod_willFinishLaunchingWithOptions = NULL;
static SEL __gESOldMethod_didRegisterUserNotificationSettings = NULL;
static SEL __gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken = NULL;
static SEL __gESOldMethod_didFailToRegisterForRemoteNotificationsWithError = NULL;
static SEL __gESOldMethod_didReceiveRemoteNotification = NULL;

static BOOL _es_application_willFinishLaunchingWithOptions(id self, SEL _cmd, UIApplication *application, NSDictionary *launchOptions)
{
        BOOL result = YES;
        [[ESApp sharedApp] _es_application:application willFinishLaunchingWithOptions:launchOptions];
        if (__gESOldMethod_willFinishLaunchingWithOptions) {
                ESInvokeSelector(self, __gESOldMethod_willFinishLaunchingWithOptions, &result, application, launchOptions);
        }
        return result;
}

static void _es_application_didRegisterUserNotificationSettings(id self, SEL _cmd, UIApplication *application, UIUserNotificationSettings *notificationSettings)
{
        [[ESApp sharedApp] _es_application:application didRegisterUserNotificationSettings:notificationSettings];
        if (__gESOldMethod_didRegisterUserNotificationSettings) {
                ESInvokeSelector(self, __gESOldMethod_didRegisterUserNotificationSettings, NULL, application, notificationSettings);
        }
}

static void _es_application_didRegisterForRemoteNotificationsWithDeviceToken(id self, SEL _cmd, UIApplication *application, NSData *deviceToken)
{
        [[ESApp sharedApp] _es_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        if (__gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken) {
                ESInvokeSelector(self, __gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken, NULL, application, deviceToken);
        }
}

static void _es_application_didFailToRegisterForRemoteNotificationsWithError(id self, SEL _cmd, UIApplication *application, NSError *error)
{
        [[ESApp sharedApp] _es_application:application didFailToRegisterForRemoteNotificationsWithError:error];
        if (__gESOldMethod_didFailToRegisterForRemoteNotificationsWithError) {
                ESInvokeSelector(self, __gESOldMethod_didFailToRegisterForRemoteNotificationsWithError, NULL, application, error);
        }
}

static void _es_application_didReceiveRemoteNotification(id self, SEL _cmd, UIApplication *application, NSDictionary *userInfo)
{
        [[ESApp sharedApp] _es_application:application didReceiveRemoteNotification:userInfo];
        if (__gESOldMethod_didReceiveRemoteNotification) {
                ESInvokeSelector(self, __gESOldMethod_didReceiveRemoteNotification, NULL, application, userInfo);
        }
}

/**
 * Hacks AppDelegate for accessing UIApplicationDelegate methods.
 *
 * 检查AppDelegate是否实现了UIApplicationDelegate的相关代理方法。
 * 给AppDelegate方法中新增UINotifications代理方法。如果AppDelegate已经实现了原始的UINotifications代理方法则
 * 交换这两个方法并在新增的方法中调用原始的实现。
 * 如果AppDelegate没有实现原始方法，添加新的实现方法并在处理完后不调用原始方法。
 * 如果原始实现了UINotifications代理而没有实现openURL，则在处理完新实现后调用原始的handleOpenURL方法。
 */
static void __ESAppHackAppDelegateMethods(void)
{
        Class AppDelegateClass = [[UIApplication sharedApplication].delegate class];
        if (!AppDelegateClass) {
                return;
        }
        
        static BOOL __gHacked = NO;
        if (__gHacked) {
                return;
        }
        __gHacked = YES;
        
        BOOL isIOS8 = [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)];
        
        SEL oldMethod_willFinishLaunchingWithOptions = @selector(application:willFinishLaunchingWithOptions:);
        SEL newMethod_willFinishLaunchingWithOptions = NSSelectorFromString(@"_esapp_application:willFinishLaunchingWithOptions:");
        IMP newMethod_willFinishLaunchingWithOptions_IMP = (IMP)_es_application_willFinishLaunchingWithOptions;
        
        SEL oldMethod_didRegisterUserNotificationSettings = isIOS8 ? @selector(application:didRegisterUserNotificationSettings:) : NULL;
        SEL oldMethod_didRegisterForRemoteNotificationsWithDeviceToken = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        SEL oldMethod_didFailToRegisterForRemoteNotificationsWithError = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
        SEL oldMethod_didReceiveRemoteNotification = @selector(application:didReceiveRemoteNotification:);
        
        SEL newMethod_didRegisterUserNotificationSettings = isIOS8 ? NSSelectorFromString(@"_esapp_application:didRegisterUserNotificationSettings:") : NULL;
        IMP newMethod_didRegisterUserNotificationSettings_IMP = isIOS8 ? (IMP)_es_application_didRegisterUserNotificationSettings : NULL;
        SEL newMethod_didRegisterForRemoteNotificationsWithDeviceToken = NSSelectorFromString(@"_esapp_application:didRegisterForRemoteNotificationsWithDeviceToken:");
        IMP newMethod_didRegisterForRemoteNotificationsWithDeviceToken_IMP = (IMP)_es_application_didRegisterForRemoteNotificationsWithDeviceToken;
        SEL newMethod_didFailToRegisterForRemoteNotificationsWithError = NSSelectorFromString(@"_esapp_application:didFailToRegisterForRemoteNotificationsWithError:");
        IMP newMethod_didFailToRegisterForRemoteNotificationsWithError_IMP = (IMP)_es_application_didFailToRegisterForRemoteNotificationsWithError;
        SEL newMethod_didReceiveRemoteNotification = NSSelectorFromString(@"_esapp_application:didReceiveRemoteNotification:");
        IMP newMethod_didReceiveRemoteNotification_IMP = (IMP)_es_application_didReceiveRemoteNotification;
        
        if ([AppDelegateClass instancesRespondToSelector:oldMethod_willFinishLaunchingWithOptions]) {
                if (class_addMethod(AppDelegateClass, newMethod_willFinishLaunchingWithOptions, newMethod_willFinishLaunchingWithOptions_IMP, "B@:@@")) {
                        __gESOldMethod_willFinishLaunchingWithOptions = newMethod_willFinishLaunchingWithOptions;
                        ESSwizzleInstanceMethod(AppDelegateClass, oldMethod_willFinishLaunchingWithOptions, newMethod_willFinishLaunchingWithOptions);
                }
        } else {
                class_addMethod(AppDelegateClass, oldMethod_willFinishLaunchingWithOptions, newMethod_willFinishLaunchingWithOptions_IMP, "B@:@@");
        }
        
        if (oldMethod_didRegisterUserNotificationSettings /* iOS8+ */) {
                if ([AppDelegateClass instancesRespondToSelector:oldMethod_didRegisterUserNotificationSettings]) {
                        /* 如果原来的appDelegate实现了这些代理方法，就记录下并在ESApp处理完后调用它 */
                        if (class_addMethod(AppDelegateClass, newMethod_didRegisterUserNotificationSettings, newMethod_didRegisterUserNotificationSettings_IMP, "v@:@@")) {
                                __gESOldMethod_didRegisterUserNotificationSettings = newMethod_didRegisterUserNotificationSettings;
                                ESSwizzleInstanceMethod(AppDelegateClass, oldMethod_didRegisterUserNotificationSettings, newMethod_didRegisterUserNotificationSettings);
                        }
                } else {
                        /* 如果没实现，则直接实现UIApplicationDelegate的方法为新IMP */
                        class_addMethod(AppDelegateClass, oldMethod_didRegisterUserNotificationSettings, newMethod_didRegisterUserNotificationSettings_IMP, "v@:@@");
                }
        }
        
        if ([AppDelegateClass instancesRespondToSelector:oldMethod_didRegisterForRemoteNotificationsWithDeviceToken]) {
                if (class_addMethod(AppDelegateClass, newMethod_didRegisterForRemoteNotificationsWithDeviceToken, newMethod_didRegisterForRemoteNotificationsWithDeviceToken_IMP, "v@:@@")) {
                        __gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken = newMethod_didRegisterForRemoteNotificationsWithDeviceToken;
                        ESSwizzleInstanceMethod(AppDelegateClass, oldMethod_didRegisterForRemoteNotificationsWithDeviceToken, newMethod_didRegisterForRemoteNotificationsWithDeviceToken);
                }
        } else {
                class_addMethod(AppDelegateClass, oldMethod_didRegisterForRemoteNotificationsWithDeviceToken, newMethod_didRegisterForRemoteNotificationsWithDeviceToken_IMP, "v@:@@");
        }
        
        if ([AppDelegateClass instancesRespondToSelector:oldMethod_didFailToRegisterForRemoteNotificationsWithError]) {
                if (class_addMethod(AppDelegateClass, newMethod_didFailToRegisterForRemoteNotificationsWithError, newMethod_didFailToRegisterForRemoteNotificationsWithError_IMP, "v@:@@")) {
                        __gESOldMethod_didFailToRegisterForRemoteNotificationsWithError = newMethod_didFailToRegisterForRemoteNotificationsWithError;
                        ESSwizzleInstanceMethod(AppDelegateClass, oldMethod_didFailToRegisterForRemoteNotificationsWithError, newMethod_didFailToRegisterForRemoteNotificationsWithError);
                }
        } else {
                class_addMethod(AppDelegateClass, oldMethod_didFailToRegisterForRemoteNotificationsWithError, newMethod_didFailToRegisterForRemoteNotificationsWithError_IMP, "v@:@@");
        }
        
        if ([AppDelegateClass instancesRespondToSelector:oldMethod_didReceiveRemoteNotification]) {
                if (class_addMethod(AppDelegateClass, newMethod_didReceiveRemoteNotification, newMethod_didReceiveRemoteNotification_IMP, "v@:@@")) {
                        __gESOldMethod_didReceiveRemoteNotification = newMethod_didReceiveRemoteNotification;
                        ESSwizzleInstanceMethod(AppDelegateClass, oldMethod_didReceiveRemoteNotification, newMethod_didReceiveRemoteNotification);
                }
        } else {
                class_addMethod(AppDelegateClass, oldMethod_didReceiveRemoteNotification, newMethod_didReceiveRemoteNotification_IMP, "v@:@@");
        }
}

void __ESApplicationDidReceiveRemoteNotification(UIApplication *application, NSDictionary *remoteNotification, BOOL fromAppLaunch)
{
        if (!application || !remoteNotification) {
                return;
        }
        
        if ([application.delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fromAppLaunch:)]) {
                ESInvokeSelector(application.delegate, @selector(application:didReceiveRemoteNotification:fromAppLaunch:), NULL, application, remoteNotification, fromAppLaunch);
        }
        
        NSDictionary *notificationUserInfo = @{(fromAppLaunch ? UIApplicationLaunchOptionsRemoteNotificationKey : ESAppRemoteNotificationKey): remoteNotification};
        [[NSNotificationCenter defaultCenter] postNotificationName:ESAppDidReceiveRemoteNotificationNotification object:application userInfo:notificationUserInfo];
}
