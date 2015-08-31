//
//  ESApp+UINotifications.m
//  ESFramework
//
//  Created by Elf Sundae on 5/23/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"
#import "NSString+ESAdditions.h"
#import <objc/runtime.h>
#import "NSError+ESAdditions.h"

NSString *const ESApplicationDidReceiveRemoteNotificationNotification = @"ESApplicationDidReceiveRemoteNotificationNotification";
NSString *const ESApplicationLaunchRemoteNotificationKey = @"ESApplicationLaunchRemoteNotificationKey";
NSString *const ESApplicationRemoteNotificationKey = @"ESApplicationRemoteNotificationKey";

ES_CATEGORY_FIX(ESApp_UINotifications)

@implementation ESApp (UINotifications)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Swizzled UIApplicationDelegate Methods

// iOS8+
- (void)_esapp_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
        if (notificationSettings.types == UIUserNotificationTypeNone) {
                // failed
                NSError *error = [NSError errorWithDomain:ESAppErrorDomain
                                                     code:ESAppErrorCodeCouldNotRegisterUserNotificationSettings
                                              description:@"Could not register UserNotificationSettings"];
                [self _esapp_application:application didFailToRegisterForRemoteNotificationsWithError:error];
        } else {
                [application registerForRemoteNotifications];
        }
}

- (void)_esapp_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        NSString *tokenString = [[deviceToken description] stringByDeletingCharactersInString:@"<> "];
        if (_esRemoteNotificationRegisterSuccessBlock) {
                _esRemoteNotificationRegisterSuccessBlock(deviceToken, tokenString);
                _esRemoteNotificationRegisterSuccessBlock = nil;
        }
}

- (void)_esapp_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
        if (_esRemoteNotificationRegisterFailureBlock) {
                _esRemoteNotificationRegisterFailureBlock(error);
                _esRemoteNotificationRegisterFailureBlock = nil;
        }
}

- (void)_esapp_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
        [self _es_applicationDidReceiveRemoteNotification:userInfo isFromAppLaunch:NO];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setCallbackForRemoteNotificationsRegistrationWithSuccess:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success failure:(void (^)(NSError *error))failure
{
        _esRemoteNotificationRegisterSuccessBlock = success;
        _esRemoteNotificationRegisterFailureBlock = failure;
}

- (void)registerForRemoteNotificationsWithTypes:(UIRemoteNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure
{
        if (0 == types) {
                if (failure) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                failure([NSError errorWithDomain:ESAppErrorDomain
                                                            code:ESAppErrorCodeRemoteNotificationTypesForRegisterIsNone
                                                     description:@"UIRemoteNotificationTypes for register is none."]);
                        });
                }
                return;
        }
        
        __ESAppHackAppDelegateUINotificationsMethods();
        
        [self setCallbackForRemoteNotificationsRegistrationWithSuccess:success failure:failure];
        
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                // iOS 8+
                UIUserNotificationType registerForTypes = (UIUserNotificationType)types;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:registerForTypes categories:categories];
                [app registerUserNotificationSettings:settings];                
        } else {
                [app registerForRemoteNotificationTypes:types];
        }
}

- (void)unregisterForRemoteNotifications
{
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

- (BOOL)isRegisteredForRemoteNotifications
{
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
                return [UIApplication sharedApplication].isRegisteredForRemoteNotifications;
        }
        return ([self enabledRemoteNotificationTypes] != 0);
}

- (UIRemoteNotificationType)enabledRemoteNotificationTypes
{
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(currentUserNotificationSettings)]) {
                UIUserNotificationType currentType = app.currentUserNotificationSettings.types;
                return (UIRemoteNotificationType)currentType;
        } else {
                return [app enabledRemoteNotificationTypes];
        }
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo isFromAppLaunch:(BOOL)fromLaunch
{
        // 留给子类实现
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Functions

/**
 * 记录原始的实现方法（其实是交换后的 _es_... 方法，在交换后的方法里调用“本身”会调用到原始方法），如果有则说明是交换过的，需要调用交换前的方法。
 */
static SEL __gESOldMethod_didRegisterUserNotificationSettings = NULL;
static SEL __gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken = NULL;
static SEL __gESOldMethod_didFailToRegisterForRemoteNotificationsWithError = NULL;
static SEL __gESOldMethod_didReceiveRemoteNotification = NULL;


static void _es_application_didRegisterUserNotificationSettings(id self, SEL _cmd, UIApplication *application, UIUserNotificationSettings *notificationSettings)
{
        [[ESApp sharedApp] _esapp_application:application didRegisterUserNotificationSettings:notificationSettings];
        if (__gESOldMethod_didRegisterUserNotificationSettings) {
                ESInvokeSelector(self, __gESOldMethod_didRegisterUserNotificationSettings, NULL, application, notificationSettings);
        }
}

static void _es_application_didRegisterForRemoteNotificationsWithDeviceToken(id self, SEL _cmd, UIApplication *application, NSData *deviceToken)
{
        [[ESApp sharedApp] _esapp_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        if (__gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken) {
                ESInvokeSelector(self, __gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken, NULL, application, deviceToken);
        }
}

static void _es_application_didFailToRegisterForRemoteNotificationsWithError(id self, SEL _cmd, UIApplication *application, NSError *error)
{
        [[ESApp sharedApp] _esapp_application:application didFailToRegisterForRemoteNotificationsWithError:error];
        if (__gESOldMethod_didFailToRegisterForRemoteNotificationsWithError) {
                ESInvokeSelector(self, __gESOldMethod_didFailToRegisterForRemoteNotificationsWithError, NULL, application, error);
        }
}

static void _es_application_didReceiveRemoteNotification(id self, SEL _cmd, UIApplication *application, NSDictionary *userInfo)
{
        [[ESApp sharedApp] _esapp_application:application didReceiveRemoteNotification:userInfo];
        if (__gESOldMethod_didReceiveRemoteNotification) {
                ESInvokeSelector(self, __gESOldMethod_didReceiveRemoteNotification, NULL, application, userInfo);
        }
}


/**
 * 检查AppDelegate是否实现了UINotifications的相关代理方法。
 * 给AppDelegate方法中新增UINotifications代理方法。如果AppDelegate已经实现了原始的UINotifications代理方法则
 * 交换这两个方法并在新增的方法中调用原始的实现。
 * 如果AppDelegate没有实现原始方法，添加新的实现方法并在处理完后不调用原始方法。
 * 如果原始实现了UINotifications代理而没有实现openURL，则在处理完新实现后调用原始的handleOpenURL方法。
 */
void __ESAppHackAppDelegateUINotificationsMethods(void)
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
        
        BOOL isIOS8 = [[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)];
        
        SEL oldMethod_didRegisterUserNotificationSettings = isIOS8 ? @selector(application:didRegisterUserNotificationSettings:) : NULL;
        SEL oldMethod_didRegisterForRemoteNotificationsWithDeviceToken = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        SEL oldMethod_didFailToRegisterForRemoteNotificationsWithError = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
        SEL oldMethod_didReceiveRemoteNotification = @selector(application:didReceiveRemoteNotification:);
        
        SEL newMethod_didRegisterUserNotificationSettings = isIOS8 ? NSSelectorFromString(@"_es_application:didRegisterUserNotificationSettings:") : NULL;
        IMP newMethod_didRegisterUserNotificationSettings_IMP = isIOS8 ? (IMP)_es_application_didRegisterUserNotificationSettings : NULL;
        SEL newMethod_didRegisterForRemoteNotificationsWithDeviceToken = NSSelectorFromString(@"_es_application:didRegisterForRemoteNotificationsWithDeviceToken:");
        IMP newMethod_didRegisterForRemoteNotificationsWithDeviceToken_IMP = (IMP)_es_application_didRegisterForRemoteNotificationsWithDeviceToken;
        SEL newMethod_didFailToRegisterForRemoteNotificationsWithError = NSSelectorFromString(@"_es_application:didFailToRegisterForRemoteNotificationsWithError:");
        IMP newMethod_didFailToRegisterForRemoteNotificationsWithError_IMP = (IMP)_es_application_didFailToRegisterForRemoteNotificationsWithError;
        SEL newMethod_didReceiveRemoteNotification = NSSelectorFromString(@"_es_application:didReceiveRemoteNotification:");
        IMP newMethod_didReceiveRemoteNotification_IMP = (IMP)_es_application_didReceiveRemoteNotification;
        
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
