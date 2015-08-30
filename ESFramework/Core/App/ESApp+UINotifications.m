//
//  ESApp+UINotifications.m
//  ESFramework
//
//  Created by Elf Sundae on 5/23/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"

ES_CATEGORY_FIX(ESApp_UINotifications)

@implementation ESApp (UINotifications)

- (void)registerForRemoteNotificationsWithTypes:(UIRemoteNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure
{
        if (![[UIApplication sharedApplication].delegate isKindOfClass:[self class]]) {
                [NSException raise:@"ESAppException" format:@"To use -registerForRemoteNotificationTypes:categories:success:failure: , the app delegate must be inherited from ESApp."];
        }

        if (0 == types) {
                if (failure) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                failure([NSError errorWithDomain:ESAppErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Remote notification types is none."}]);
                        });
                }
                return;
        }
        
        _esRemoteNotificationRegisterSuccessBlock = success;
        _esRemoteNotificationRegisterFailureBlock = failure;
        
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

@end
