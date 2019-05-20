//
//  UIDevice+ESInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (ESAdditions)

/**
 * The device token for the Apple Push Notification service (APNs).
 * @discussion The value of device token will be automatically set after calling
 * -[UIApplication registerForRemoteNotifications].
 * This property is KVO-compliant.
 */
@property (nullable, nonatomic, copy) NSData *deviceToken;

/**
 * The device token string for the Apple Push Notification service (APNs).
 * @discussion This property is KVO-compliant.
 */
@property (nullable, nonatomic, copy, readonly) NSString *deviceTokenString;

/**
 * Returns the model identifier of the device.
 * e.g. "iPhone3,1", "iPhone11,2".
 * https://www.theiphonewiki.com/wiki/Models
 */
@property (nonatomic, readonly) NSString *modelIdentifier;

/**
 * Returns the model name of the device.
 * e.g. "iPhone 6 Plus", "iPad Pro"
 */
@property (nonatomic, readonly) NSString *modelName;

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
 * the screen size in points.
 */
@property (nonatomic, readonly) CGSize screenSizeInPoints;

/**
 * The screen size in pixels.
 */
@property (nonatomic, readonly) CGSize screenSizeInPixels;

/**
 * Detects whether this device has been jailbroken.
 */
@property (nonatomic, readonly) BOOL isJailbroken;

@end

NS_ASSUME_NONNULL_END
