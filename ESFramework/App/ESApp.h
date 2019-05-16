//
//  ESApp.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

/**
 * Posts when received remote notifications.
 * Keys for userInfo: UIApplicationLaunchOptionsRemoteNotificationKey or ESAppRemoteNotificationKey
 */
FOUNDATION_EXTERN NSString *const ESAppDidReceiveRemoteNotificationNotification;
FOUNDATION_EXTERN NSString *const ESAppRemoteNotificationKey;

FOUNDATION_EXTERN NSString *const ESAppErrorDomain;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESAppDelegate

@protocol ESAppDelegate <NSObject>
@optional

/**
 * Invoked when `-application:didReceiveRemoteNotification:` and the first applicationDidBecomeActive if there is an APNS object in UIApplicationLaunchOptionsRemoteNotificationKey.
 *
 * If your app delegate is not a subclass of ESApp, you can also implement this delegate method to receive remote notifications.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)remoteNotification fromAppLaunch:(BOOL)fromLaunch;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp

/**
 * `ESApp` is designed as the delegate of UIApplication, it can also be used as a global helper class.
 */
@interface ESApp : UIResponder <UIApplicationDelegate, ESAppDelegate>

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications

@interface ESApp (_Notifications)
/**
 * @note success可能会延迟回调。例如：用户在系统设置里关闭了app的通知，调用register时会回调failure,
 * 如果用户在app运行期间去系统设置里打开了app的push通知，此时会回调success。
 *
 * `categories` is only for iOS8+, contains instances of UIUserNotificationCategory or UNNotificationCategory (iOS10+).
 */
- (void)registerForRemoteNotificationsWithTypes:(UIUserNotificationType)types
                                     categories:(NSSet *)categories
                                        success:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success
                                        failure:(void (^)(NSError *error))failure;
- (void)setCallbackForRemoteNotificationsRegistrationWithSuccess:(void (^)(NSData *deviceToken, NSString *deviceTokenString))success failure:(void (^)(NSError *error))failure;
- (void)unregisterForRemoteNotifications;
- (BOOL)isRegisteredForRemoteNotifications;
- (UIUserNotificationType)enabledRemoteNotificationTypes;
- (NSString *)remoteNotificationsDeviceToken;

@end
