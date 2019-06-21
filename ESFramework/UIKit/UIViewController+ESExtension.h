//
//  UIViewController+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

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

#endif
