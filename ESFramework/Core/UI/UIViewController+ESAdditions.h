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

@end
