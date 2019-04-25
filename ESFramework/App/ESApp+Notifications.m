//
//  ESApp+UINotifications.m
//  ESFramework
//
//  Created by Elf Sundae on 5/23/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "_ESApp_Private.h"
#import "NSString+ESAdditions.h"
#import "NSError+ESAdditions.h"
#import <UserNotifications/UserNotifications.h>

NSString *const ESAppDidReceiveRemoteNotificationNotification = @"ESAppDidReceiveRemoteNotificationNotification";
NSString *const ESAppRemoteNotificationKey = @"ESAppRemoteNotificationKey";

static NSString *__gRemoteNotificationsDeviceToken = nil;

static void (^__gRemoteNotificationRegisterSuccessBlock)(NSData *deviceToken, NSString *deviceTokenString) = nil;
static void (^__gRemoteNotificationRegisterFailureBlock)(NSError *error) = nil;

/**
 * Called when failed to register remote notification.
 *
 * It will invoke application delegate's `-application:didFailToRegisterForRemoteNotificationsWithError:` method.
 * that actually `es_application_didFailToRegisterForRemoteNotificationsWithError()` will be called because we have
 * swizzled `-application:didFailToRegisterForRemoteNotificationsWithError:` in `es_hackAppDelegateForNotifications`.
 */
static void es_didFailToRegisterForRemoteNotificationsWithError(NSError *error)
{
    UIApplication *app = [UIApplication sharedApplication];

    if ([app.delegate respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
        [app.delegate application:app didFailToRegisterForRemoteNotificationsWithError:error];
    }
}

@implementation ESApp (_Notifications)

- (void)registerForRemoteNotificationsWithTypes:(UIUserNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure
{
    [self setCallbackForRemoteNotificationsRegistrationWithSuccess:success failure:failure];

    UIApplication *app = [UIApplication sharedApplication];

    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:(UNAuthorizationOptions)types
                       completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                if ([categories.anyObject isKindOfClass:[UNNotificationCategory class]]) {
                    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
                }

                [app registerForRemoteNotifications];
            } else {
                error = error ?: [NSError errorWithDomain:ESAppErrorDomain
                                                     code:0
                                              description:@"Failed to request user authorization for notifications."];
                es_didFailToRegisterForRemoteNotificationsWithError(error);
            }
        }];
    } else {
        categories = [categories.anyObject isKindOfClass:[UIUserNotificationCategory class]] ? categories : nil;
        [app registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types categories:categories]];
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

/**
 * 记录原始的实现方法（其实是交换后的 _es_... 方法，在交换后的方法里调用“本身”会调用到原始方法），如果有则说明是交换过的，需要调用交换前的方法。
 */
static SEL __original_didRegisterUserNotificationSettings = NULL;
static SEL __original_didRegisterForRemoteNotificationsWithDeviceToken = NULL;
static SEL __original_didFailToRegisterForRemoteNotificationsWithError = NULL;
static SEL __original_didReceiveRemoteNotification = NULL;

static void es_application_didRegisterUserNotificationSettings(id self, SEL _cmd, UIApplication *application, UIUserNotificationSettings *notificationSettings)
{
    if (__original_didRegisterUserNotificationSettings) {
        ESInvokeSelector(self, __original_didRegisterUserNotificationSettings, NULL, application, notificationSettings);
    }

    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    } else {
        NSError *error = [NSError errorWithDomain:ESAppErrorDomain
                                             code:0
                                      description:@"Failed to register user notification settings."];
        es_didFailToRegisterForRemoteNotificationsWithError(error);
    }
}

static void es_application_didRegisterForRemoteNotificationsWithDeviceToken(id self, SEL _cmd, UIApplication *application, NSData *deviceToken)
{
    if (__original_didRegisterForRemoteNotificationsWithDeviceToken) {
        ESInvokeSelector(self, __original_didRegisterForRemoteNotificationsWithDeviceToken, NULL, application, deviceToken);
    }

    __gRemoteNotificationsDeviceToken = [[deviceToken description] stringByDeletingCharactersInString:@"<> "];

    if (__gRemoteNotificationRegisterSuccessBlock) {
        __gRemoteNotificationRegisterSuccessBlock(deviceToken, __gRemoteNotificationsDeviceToken);
        __gRemoteNotificationRegisterSuccessBlock = nil;
    }
}

static void es_application_didFailToRegisterForRemoteNotificationsWithError(id self, SEL _cmd, UIApplication *application, NSError *error)
{
    if (__original_didFailToRegisterForRemoteNotificationsWithError) {
        ESInvokeSelector(self, __original_didFailToRegisterForRemoteNotificationsWithError, NULL, application, error);
    }

    if (__gRemoteNotificationRegisterFailureBlock) {
        __gRemoteNotificationRegisterFailureBlock(error);
        __gRemoteNotificationRegisterFailureBlock = nil;
    }
}

static void es_application_didReceiveRemoteNotification(id self, SEL _cmd, UIApplication *application, NSDictionary *userInfo)
{
    if (__original_didReceiveRemoteNotification) {
        ESInvokeSelector(self, __original_didReceiveRemoteNotification, NULL, application, userInfo);
    }

    es_didReceiveRemoteNotification(userInfo, NO);
}

/**
 * Swizzle a selector with an implementation function.
 */
static BOOL es_swizzleImplementation(Class cls, SEL selector, IMP imp, const char *types, SEL *originalSelector)
{
    SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"_es_swizzled_%@", NSStringFromSelector(selector)]);

    if ([cls instancesRespondToSelector:selector]) {
        if (class_addMethod(cls, swizzledSelector, imp, types)) {
            ESSwizzleInstanceMethod(cls, selector, swizzledSelector);

            if (originalSelector) {
                *originalSelector = swizzledSelector;
            }

            return YES;
        }
    } else {
        class_addMethod(cls, selector, imp, types);

        if (originalSelector) {
            *originalSelector = NULL;
        }

        return YES;
    }

    return NO;
}

void es_hackAppDelegateForNotifications(id<UIApplicationDelegate> delegate)
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            es_swizzleImplementation(
                [delegate class],
                @selector(application:didRegisterUserNotificationSettings:),
                (IMP)es_application_didRegisterUserNotificationSettings,
                "v@:@@",
                &__original_didRegisterUserNotificationSettings
                );
        }

        es_swizzleImplementation(
            [delegate class],
            @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:),
            (IMP)es_application_didRegisterForRemoteNotificationsWithDeviceToken,
            "v@:@@",
            &__original_didRegisterForRemoteNotificationsWithDeviceToken
            );

        es_swizzleImplementation(
            [delegate class],
            @selector(application:didFailToRegisterForRemoteNotificationsWithError:),
            (IMP)es_application_didFailToRegisterForRemoteNotificationsWithError,
            "v@:@@",
            &__original_didFailToRegisterForRemoteNotificationsWithError
            );

        es_swizzleImplementation(
            [delegate class],
            @selector(application:didReceiveRemoteNotification:),
            (IMP)es_application_didReceiveRemoteNotification,
            "v@:@@",
            &__original_didReceiveRemoteNotification
            );
    });
}

void es_didReceiveRemoteNotification(NSDictionary *remoteNotification, BOOL fromLaunch)
{
    if (![remoteNotification isKindOfClass:[NSDictionary class]]) {
        return;
    }

    UIApplication *application = [UIApplication sharedApplication];

    ESInvokeSelector(application.delegate, @selector(application:didReceiveRemoteNotification:fromAppLaunch:), NULL, application, remoteNotification, fromLaunch);

    NSString *userInfoKey = (fromLaunch ? UIApplicationLaunchOptionsRemoteNotificationKey : ESAppRemoteNotificationKey);
    [[NSNotificationCenter defaultCenter] postNotificationName:ESAppDidReceiveRemoteNotificationNotification
                                                        object:application
                                                      userInfo:@{ userInfoKey: remoteNotification }];
}