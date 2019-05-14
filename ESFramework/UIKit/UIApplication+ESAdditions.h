//
//  UIApplication+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ESAdditions)

@end

@interface UIApplication (ESAppInfo)

/// The name of the executable in the main bundle.
@property (readonly) NSString *appName;
@property (readonly) NSString *appBundleName;
@property (readonly) NSString *appDisplayName;
@property (readonly) NSString *appBundleIdentifier;
@property (readonly) NSString *appVersion;
@property (readonly) NSString *appBuildVersion;
/// e.g. "1.2.4 (210)"
@property (readonly) NSString *appFullVersion;
@property (readonly) BOOL isUIViewControllerBasedStatusBarAppearance;

@property (nonatomic, readonly) NSDate *appLaunchDate;
@property (nonatomic, readonly) NSTimeInterval appLaunchDuration;

/**
 * Indicates whether the current app launch is a "fresh launch" which means the
 * first time of app launch after the app was installed or upgraded.
 */
@property (nonatomic, readonly) BOOL isFreshLaunch;

/**
 * Returns the app version before the current launching.
 */
@property (nullable, nonatomic, readonly) NSString *appPreviousVersion;

/**
 * Returns the app analytics information.
 */
- (NSDictionary *)analyticsInfo;

@end

NS_ASSUME_NONNULL_END
