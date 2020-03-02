//
//  UIDevice+ESInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/13.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ESExtension)

/**
 * The device token for the Apple Push Notification service (APNs).
 * @discussion The value of device token will be automatically set after calling
 * -[UIApplication registerForRemoteNotifications].
 * This property is KVO-compliant.
 */
@property (nullable, nonatomic, copy) NSData *deviceToken;

/**
 * Returns the device token string for the Apple Push Notification service (APNs).
 * @discussion This property is KVO-compliant.
 */
@property (nullable, nonatomic, readonly) NSString *deviceTokenString;

/**
 * Returns the model identifier of the device.
 * @discussion e.g. "iPhone3,1", "AppleTV5,3", "Watch4,3".
 * https://github.com/ElfSundae/iOS-Model-List
 */
@property (nonatomic, readonly) NSString *modelIdentifier;

/**
 * Returns the model name of the device.
 * @discussion e.g. "iPhone 6 Plus", "iPhone XS Max", "iPad Pro 3 (12.9-inch)",
 * "Apple TV 4K", "Apple Watch Series 4 (44mm)", "Simulator x86", "Simulator x64".
 * https://github.com/ElfSundae/iOS-Model-List
 */
@property (nonatomic, readonly) NSString *modelName;

/**
 * Returns the screen size in points.
 */
@property (nonatomic, readonly) CGSize screenSizeInPoints;

/**
 * Returns the screen size in pixels.
 */
@property (nonatomic, readonly) CGSize screenSizeInPixels;

/**
 * Returns the total disk space in bytes.
 */
@property (nonatomic, readonly) long long diskTotalSpace;

/**
 * Returns a string whose value indicates the total disk space, e.g. "63.99 GB".
 */
@property (nonatomic, readonly) NSString *diskTotalSpaceString;

/**
 * Returns the free disk space in bytes.
 */
@property (nonatomic, readonly) long long diskFreeSpace;

/**
 * Returns a string whose value indicates the free disk space, e.g. "11.23 GB".
 */
@property (nonatomic, readonly) NSString *diskFreeSpaceString;

/**
 * Returns the used disk space in bytes.
 */
@property (nonatomic, readonly) long long diskUsedSpace;

/**
 * Returns a string whose value indicates the used disk space, e.g. "11.23 GB".
 */
@property (nonatomic, readonly) NSString *diskUsedSpaceString;

/**
 * Detects whether this device has been jailbroken.
 */
@property (nonatomic, readonly) BOOL isJailbroken API_UNAVAILABLE(tvos);

@end

NS_ASSUME_NONNULL_END

#endif
