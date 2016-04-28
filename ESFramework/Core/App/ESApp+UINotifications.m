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

NSString *const ESAppDidReceiveRemoteNotificationNotification = @"ESAppDidReceiveRemoteNotificationNotification";
NSString *const ESAppRemoteNotificationKey = @"ESAppRemoteNotificationKey";

static NSString *__gRemoteNotificationsDeviceToken = nil;
static void (^__gRemoteNotificationRegisterSuccessBlock)(NSData *deviceToken, NSString *deviceTokenString) = nil;
static void (^__gRemoteNotificationRegisterFailureBlock)(NSError *error) = nil;

@implementation ESApp (_UINotifications)

- (void)registerForRemoteNotificationsWithTypes:(UIUserNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure
{
        [self setCallbackForRemoteNotificationsRegistrationWithSuccess:success failure:failure];
        
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
                [app registerUserNotificationSettings:settings];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                [app registerForRemoteNotificationTypes:(UIRemoteNotificationType)types];
#pragma clang diagnostic pop
        }
}

- (void)setCallbackForRemoteNotificationsRegistrationWithSuccess:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success failure:(void (^)(NSError *error))failure
{
        __gRemoteNotificationRegisterSuccessBlock = [success copy];
        __gRemoteNotificationRegisterFailureBlock = [failure copy];
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

- (UIUserNotificationType)enabledRemoteNotificationTypes
{
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(currentUserNotificationSettings)]) {
                return app.currentUserNotificationSettings.types;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                return (UIUserNotificationType)[app enabledRemoteNotificationTypes];
#pragma clang diagnostic pop
        }
}

- (NSString *)remoteNotificationsDeviceToken
{
        return __gRemoteNotificationsDeviceToken;
}

@end

void _ESDidReceiveRemoteNotification(UIApplication *application, NSDictionary *remoteNotification, BOOL fromLaunch)
{
        if (![remoteNotification isKindOfClass:[NSDictionary class]]) {
                return;
        }
        if ([application.delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fromAppLaunch:)]) {
                ESInvokeSelector(application.delegate, @selector(application:didReceiveRemoteNotification:fromAppLaunch:), NULL, application, remoteNotification, fromLaunch);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ESAppDidReceiveRemoteNotificationNotification
                                                            object:application
                                                          userInfo:@{ (fromLaunch ? UIApplicationLaunchOptionsRemoteNotificationKey : ESAppRemoteNotificationKey) : remoteNotification}];
}

/**
 * 记录原始的实现方法（其实是交换后的 _es_... 方法，在交换后的方法里调用“本身”会调用到原始方法），如果有则说明是交换过的，需要调用交换前的方法。
 */
static SEL __gESOldMethod_didRegisterUserNotificationSettings = NULL;
static SEL __gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken = NULL;
static SEL __gESOldMethod_didFailToRegisterForRemoteNotificationsWithError = NULL;
static SEL __gESOldMethod_didReceiveRemoteNotification = NULL;

static void _es_application_didRegisterUserNotificationSettings(id self, SEL _cmd, UIApplication *application, UIUserNotificationSettings *notificationSettings)
{
        [application registerForRemoteNotifications];
        
        if (__gESOldMethod_didRegisterUserNotificationSettings) {
                ESInvokeSelector(self, __gESOldMethod_didRegisterUserNotificationSettings, NULL, application, notificationSettings);
        }
}

static void _es_application_didRegisterForRemoteNotificationsWithDeviceToken(id self, SEL _cmd, UIApplication *application, NSData *deviceToken)
{
        NSString *tokenString = [[deviceToken description] stringByDeletingCharactersInString:@"<> "];
        __gRemoteNotificationsDeviceToken = [tokenString copy];
        
        if (__gRemoteNotificationRegisterSuccessBlock) {
                __gRemoteNotificationRegisterSuccessBlock(deviceToken, tokenString);
                __gRemoteNotificationRegisterSuccessBlock = nil;
        }
        
        if (__gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken) {
                ESInvokeSelector(self, __gESOldMethod_didRegisterForRemoteNotificationsWithDeviceToken, NULL, application, deviceToken);
        }
}

static void _es_application_didFailToRegisterForRemoteNotificationsWithError(id self, SEL _cmd, UIApplication *application, NSError *error)
{
        if (__gRemoteNotificationRegisterFailureBlock) {
                __gRemoteNotificationRegisterFailureBlock(error);
                __gRemoteNotificationRegisterFailureBlock = nil;
        }

        if (__gESOldMethod_didFailToRegisterForRemoteNotificationsWithError) {
                ESInvokeSelector(self, __gESOldMethod_didFailToRegisterForRemoteNotificationsWithError, NULL, application, error);
        }
}

static void _es_application_didReceiveRemoteNotification(id self, SEL _cmd, UIApplication *application, NSDictionary *userInfo)
{
        _ESDidReceiveRemoteNotification(application, userInfo, NO);
        if (__gESOldMethod_didReceiveRemoteNotification) {
                ESInvokeSelector(self, __gESOldMethod_didReceiveRemoteNotification, NULL, application, userInfo);
        }
}

/**
 * Hack AppDelegate for UINotifications methods.
 *
 * 检查AppDelegate是否实现了UIApplicationDelegate的相关代理方法。
 * 给AppDelegate方法中新增UINotifications代理方法。如果AppDelegate已经实现了原始的UINotifications代理方法则
 * 交换这两个方法并在新增的方法中调用原始的实现。
 * 如果AppDelegate没有实现原始方法，添加新的实现方法并在处理完后不调用原始方法。
 */
void _ESAppHackAppDelegateForUINotifications(void)
{
        Class AppDelegateClass = [[UIApplication sharedApplication].delegate class];
        if (!AppDelegateClass) {
                return;
        }
        
#define DISPATCH_ONCE_BEGIN     static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
#define DISPATCH_ONCE_END       });
        
        DISPATCH_ONCE_BEGIN
        BOOL isIOS8 = [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)];
        
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
        DISPATCH_ONCE_END
}
