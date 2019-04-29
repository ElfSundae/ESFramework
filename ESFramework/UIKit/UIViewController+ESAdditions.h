//
//  UIViewController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ESAdditions)

/**
 * The previous view controller from this view controller, in navigation controller's stack.
 */
- (nullable UIViewController *)previousViewController;

/**
 * The next view controller from this view controller, in navigation controller's stack.
 */
- (nullable UIViewController *)nextViewController;

/**
 * Returns `YES` when viewLoaded and viewVisible(it's `window` is not `nil`).
 */
- (BOOL)isViewVisible;

/**
 * Returns UITabBarController's selected controller or UINavigationController's topViewController,
 * or this controller itself.
 *
 * @note it returns the current "visible" UIViewController, not the "real" controller such as UINavigationController in a UITabBarController.
 *
 */
- (UIViewController *)currentVisibleViewController;

@end

NS_ASSUME_NONNULL_END
