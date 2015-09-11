//
//  ESApp+Private.h
//  ESFramework
//
//  Created by Elf Sundae on 5/23/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@interface ESApp ()
{
@private
        NSString *_esWebViewDefaultUserAgent;
        UIBackgroundTaskIdentifier _esBackgroundTaskIdentifier;
        
        void (^_esRemoteNotificationRegisterSuccessBlock)(NSData *deviceToken, NSString *deviceTokenString);
        void (^_esRemoteNotificationRegisterFailureBlock)(NSError *error);
        NSString *_esRemoteNotificationsDeviceToken;
        NSDictionary *_esRemoteNotificationFromLaunch;
}

- (void)_es_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fromAppLaunch:(BOOL)fromLaunch;

@end

ES_EXTERN void __ESAppHackAppDelegateUINotificationsMethods(void);