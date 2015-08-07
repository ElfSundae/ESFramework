//
//  ESApp+UINotifications.m
//  ESFramework
//
//  Created by Elf Sundae on 5/23/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"

ES_IMPLEMENTATION_CATEGORY_FIX(ESApp, UINotifications)

- (void)registerForRemoteNotificationsWithTypes:(UIRemoteNotificationType)types success:(void (^)(NSString *deviceToken))success failure:(void (^)(NSError *error))failure
{
        if (![[UIApplication sharedApplication].delegate isKindOfClass:[self class]]) {
                [NSException raise:@"ESAppException" format:@"To use -registerForRemoteNotificationTypes:success:failure: , your application delegate must be inherited from ESApp."];
        }

        if (0 == types) {
                if (failure) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                failure([NSError errorWithDomain:ESAppErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Remote notification types is none."}]);
                        });
                }
                return;
        }
        
        _esRemoteNotificationRegisterSuccessBlock = success;
        _esRemoteNotificationRegisterFailureBlock = failure;
        
        UIApplication *app = [UIApplication sharedApplication];
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                // iOS 8+
                UIUserNotificationSettings *currentSettings = app.currentUserNotificationSettings;
                UIUserNotificationType currentType = currentSettings.types;
                UIUserNotificationType registerForTypes = (UIUserNotificationType)types;
                if (currentType != registerForTypes) {
                        UIUserNotificationSettings *settings =
                        [UIUserNotificationSettings settingsForTypes:registerForTypes categories:nil];
                        [app registerUserNotificationSettings:settings];
                } else {
                        [app registerForRemoteNotifications];
                }
                
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
