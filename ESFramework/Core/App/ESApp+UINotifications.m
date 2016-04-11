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

NSString *const ESUserNotificationSettingsErrorKey = @"ESUIUserNotificationSettingsErrorKey";
NSString *const ESAppDidReceiveRemoteNotificationNotification = @"ESAppDidReceiveRemoteNotificationNotification";
NSString *const ESAppRemoteNotificationKey = @"ESAppRemoteNotificationKey";

@implementation ESApp (_UINotifications)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)registerForRemoteNotificationsWithTypes:(UIUserNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure
{
        if (0 == types) {
                if (failure) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                failure([NSError errorWithDomain:ESAppErrorDomain
                                                            code:ESAppErrorCodeRemoteNotificationTypesIsNone
                                                     description:@"UIRemoteNotificationTypes for register is none."]);
                        });
                }
                return;
        }
        
        [self setCallbackForRemoteNotificationsRegistrationWithSuccess:success failure:failure];
        
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                // iOS 8+
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
                [app registerUserNotificationSettings:settings];                
        } else {
                [app registerForRemoteNotificationTypes:(UIRemoteNotificationType)types];
        }
}

- (void)setCallbackForRemoteNotificationsRegistrationWithSuccess:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success failure:(void (^)(NSError *error))failure
{
        __esRemoteNotificationRegisterSuccessBlock = [success copy];
        __esRemoteNotificationRegisterFailureBlock = [failure copy];
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
                UIUserNotificationType currentType = app.currentUserNotificationSettings.types;
                return currentType;
        } else {
                return (UIUserNotificationType)[app enabledRemoteNotificationTypes];
        }
}

- (NSString *)remoteNotificationsDeviceToken
{
        return __esRemoteNotificationsDeviceToken;
}

@end

@implementation ESApp (_UINotificationsPrivate)

- (void)_es_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
        if (UIUserNotificationTypeNone == notificationSettings.types) {
                NSError *error = [NSError errorWithDomain:ESAppErrorDomain
                                                     code:ESAppErrorCodeCouldNotRegisterUserNotificationSettings
                                                 userInfo:@{ NSLocalizedDescriptionKey: @"Could not register UserNotificationSettings.",
                                                             ESUserNotificationSettingsErrorKey: notificationSettings}];
                [self _es_application:application didFailToRegisterForRemoteNotificationsWithError:error];
        } else {
                [application registerForRemoteNotifications];
        }
}

- (void)_es_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
        NSString *tokenString = [[deviceToken description] stringByDeletingCharactersInString:@"<> "];
        __esRemoteNotificationsDeviceToken = [tokenString copy];
        
        if (__esRemoteNotificationRegisterSuccessBlock) {
                __esRemoteNotificationRegisterSuccessBlock(deviceToken, tokenString);
                __esRemoteNotificationRegisterSuccessBlock = nil;
        }
        
}

- (void)_es_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
        if (__esRemoteNotificationRegisterFailureBlock) {
                __esRemoteNotificationRegisterFailureBlock(error);
                __esRemoteNotificationRegisterFailureBlock = nil;
        }
}

- (void)_es_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
        __ESApplicationDidReceiveRemoteNotification(application, userInfo, NO);
}

@end
