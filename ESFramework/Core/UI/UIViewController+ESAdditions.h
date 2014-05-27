//
//  UIViewController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ESAdditions)

/**
 * The previous view controller from this view controller, in navigation controller's stack.
 */
- (UIViewController *)previousViewController;

/**
 * The next view controller from this view controller, in navigation controller's stack.
 */
- (UIViewController *)nextViewController;

/**
 * Returns `YES` when viewLoaded and viewVisible(it's `window` is not `nil`).
 */
- (BOOL)isViewVisible;

/**
 * Returns UITabBarController's selected controller or UINavigationController's visibleController,
 * or this controller itself.
 */
- (UIViewController *)currentVisibleViewController;

@end
