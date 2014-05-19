//
//  UIView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDefines.h"

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

/**
 * Search in supviews or subviews to find a `UIView` instance which is kind of `class_`.
 */
- (UIView *)findViewWithClass:(Class)class_ shouldSearchInSuperview:(BOOL)shouldSearchInSuperview;

/**
 * Returns `UIViewController` which manages this view.
 */
- (UIViewController *)viewController;

/**
 * Add an UITapGestureRecognizer with block way.
 */
- (UITapGestureRecognizer *)addTapGestureHandler:(void (^)(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView))handler;
/**
 * Add an UILongPressGestureRecognizer with block way.
 */
- (UILongPressGestureRecognizer *)addLongPressGestureHandler:(void (^)(UILongPressGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView))handler;

@end
