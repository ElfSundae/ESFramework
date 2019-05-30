//
//  UIViewController+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ESExtension)

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

@end

NS_ASSUME_NONNULL_END
