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
 * e.g. @"iPhone3,1", @"x86_64".
 * http://theiphonewiki.com/wiki/Models
 */
@property (nonatomic, readonly) NSString *platform;

/**
 * Returns the total disk space in bytes.
 */
@property (nonatomic, readonly) long long diskSpace;

/**
 * Returns a string whose value indicates the total disk space, e.g. "63.99 GB".
 */
@property (nonatomic, readonly) NSString *diskSpaceString;

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
