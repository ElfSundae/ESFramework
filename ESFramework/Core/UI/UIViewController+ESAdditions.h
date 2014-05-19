//
//  UIViewController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 
 * ### Note
 *
 * @warning This category has swizzled `-viewDidLoad` on iOS7.0+, to fix [iOS 7 push/pop issue](http://stackoverflow.com/q/18881427)
 *
 */
@interface UIViewController (ESAdditions)

/**
 * The previous view controller from this view controller, in navigation controller's stack.
 */
- (UIViewController *)previousViewController;

/**
 * The next view controller from this view controller, in navigation controller's stack.
 */
- (UIViewController *)nextViewController;

@end
