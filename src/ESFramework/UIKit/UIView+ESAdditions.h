//
//  UIView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ESAdditions)

/**
 * Returns the first responder of this view.
 */
- (UIView *)findFirstResponder;

/**
 * Find and resign the first responder of this view.
 */
- (BOOL)findAndResignFirstResponder;

/**
 * Remove all subviews.
 */
- (void)removeAllSubviews;

@end
