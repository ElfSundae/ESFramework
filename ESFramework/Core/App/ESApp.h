//
//  ESApp.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"

/**
 * `ESApp` is designed as the delegate of UIApplication, also it can be used
 * as a global helper class.
 *
 * If your application delegate is a subclass of `ESApp`, the `-application:didFinishLaunchingWithOptions:` defines
 * in `<UIApplicationDelegate>` has been implemented.
 * And ESApp has done the following things:
 *
 *      + Setup window
 *      //+ Setup Root View Controller
 *      + Set the UserAgent for UIWebView, see -userAgentForWebView;
 *      + Enable multitasking, see +enableMultitasking;
 *      + Save UIApplicationLaunchOptionsRemoteNotification value to self.remoteNotification
 *
 *
 */
@interface ESApp : UIResponder <UIApplicationDelegate>

/**
 * Returns the application delegate if the `AppDelegate` is a subclass of `ESApp`, 
 * otherwise returns a shared `ESApp` instance.
 */
+ (instancetype)sharedApp;

@property (nonatomic, strong) UIWindow *window;

/**
 * You can overwrite property `rootViewController` and @dynamic it 
 * in your app delegate implementation file, to specify a different type instead
 * `UIViewController`.
 */
@property (nonatomic, strong) UIViewController *rootViewController;

/**
 * Remote notification userInfo.
 */
@property (nonatomic, strong) NSDictionary *remoteNotification;
/**
 * The device token for the remote notification.
 */
@property (nonatomic, copy) NSString *remoteNotificationsDeviceToken;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESApp (Notification)

@interface ESApp (Notification)
/**
 * If register succueed, handler's `sender` will be the device token (NSString type without blank characters.),
 * otherwise `sender` will be a NSError object.
 */
- (void)registerRemoteNotificationTypes:(UIRemoteNotificationType)types success:(void (^)(NSString *deviceToken))success failure:(void (^)(NSError *error))failure;

@end
