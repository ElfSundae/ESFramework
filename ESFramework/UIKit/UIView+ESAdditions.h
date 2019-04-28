//
//  UIView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ESAdditions)

/// frame.origin
@property (nonatomic) CGPoint origin;
/// frame.size
@property (nonatomic) CGSize size;
/// frame.origin.x
@property (nonatomic) CGFloat left;
/// frame.origin.y
@property (nonatomic) CGFloat top;
/// frame.origin.x + frame.size.width
@property (nonatomic) CGFloat right;
/// frame.origin.y + frame.size.height
@property (nonatomic) CGFloat bottom;
/// frame.size.width
@property (nonatomic) CGFloat width;
/// frame.size.height
@property (nonatomic) CGFloat height;
/// center.x
@property (nonatomic) CGFloat centerX;
/// center.y
@property (nonatomic) CGFloat centerY;

/**
 * Returns a snapshot image of the view hierarchy.
 */
- (UIImage *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates;

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
- (UIView *)findSuperviewOf:(Class)viewClass;

/**
 * Searches in subviews recursively to find the view which its class is the given viewClass.
 */
- (UIView *)findSubviewOf:(Class)viewClass;

/**
 * Returns the UIViewController instance which manages this view.
 */
- (UIViewController *)viewController;

/// Set layer.mask, rounds all corners with the same horizontal and vertical radius
/// @see http://stackoverflow.com/a/5826745
- (void)setMaskLayerWithCornerRadius:(CGFloat)cornerRadius;
/// Set layer.mask
/// @see http://stackoverflow.com/a/5826745
- (void)setMaskLayerByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/// self.layer.masksToBounds = YES;
- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
/// self.layer.masksToBounds = NO;
- (void)setLayerShadowWithColor:(UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;
/// insert `CAGradientLayer` at index 0.
- (void)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;
/// insert `CAGradientLayer` at index 0.
- (void)setBackgroundGradientColor:(UIColor *)startColor, ... NS_REQUIRES_NIL_TERMINATION;

/// =============================================
/// @name Debug Border
/// =============================================

- (void)enableDebugBorder;
- (void)enableDebugBorderWithColor:(UIColor *)color;

/// =============================================
/// @name View Hierarchy
/// =============================================

- (NSUInteger)indexOnSuperview;
- (void)bringToFront;
- (void)sendToBack;
- (BOOL)isInFrontOfSuperview;
- (BOOL)isAtBackOfSuperview;

- (void)moveToCenterOfSuperview;

@end
