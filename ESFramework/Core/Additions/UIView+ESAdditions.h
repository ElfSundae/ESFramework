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
 * Searches in superviews recursively to find the view which its class is the given viewClass.
 */
- (UIView *)findViewWithClassInSuperviews:(Class)viewClass;

/**
 * Searches in subviews recursively to find the view which its class is the given viewClass.
 */
- (UIView *)findViewWithClassInSubviews:(Class)viewClass;

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
 *
 * @warning `handler` will be invoked when the state of gesture recognizer becomes UIGestureRecognizerStateBegan.
 */
- (UILongPressGestureRecognizer *)addLongPressGestureHandler:(void (^)(UILongPressGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView))handler;

- (NSArray *)allTapGestureRecognizers;
- (NSArray *)allLongPressGestureRecognizers;
- (NSArray *)allPanGestureRecognizers;
- (NSArray *)allPinchGestureRecognizers;
- (NSArray *)allSwipeGestureRecognizers;
- (NSArray *)allRotationGestureRecognizers;

- (void)removeAllTapGestureRecognizers;
- (void)removeAllLongPressGestureRecognizers;
- (void)removeAllPanGestureRecognizers;
- (void)removeAllPinchGestureRecognizers;
- (void)removeAllSwipeGestureRecognizers;
- (void)removeAllRotationGestureRecognizers;

/// Set layer.mask, rounds all corners with the same horizontal and vertical radius
/// @see http://stackoverflow.com/a/5826745
- (void)setMaskLayerWithCornerRadius:(CGFloat)cornerRadius;
/// Set layer.mask
/// @see http://stackoverflow.com/a/5826745
- (void)setMaskLayerByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/// self.layer.masksToBounds = YES;
- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/// self.layer.masksToBounds = NO;
- (void)setShadowOffset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;
/// insert `CAGradientLayer` at index 0.
- (void)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;
/// insert `CAGradientLayer` at index 0.
- (void)setBackgroundGradientColor:(UIColor *)startColor, ... NS_REQUIRES_NIL_TERMINATION;

///=============================================
/// @name Debug Border
///=============================================

- (void)enableDebugBorder;
- (void)enableDebugBorderWithColor:(UIColor *)color;

///=============================================
/// @name View Hierarchy
///=============================================

- (NSUInteger)indexOnSuperview;
- (void)bringToFront;
- (void)sendToBack;
- (BOOL)isInFrontOfSuperview;
- (BOOL)isAtBackOfSuperview;

- (void)moveToCenterOfSuperview;

@end
