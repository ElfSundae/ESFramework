//
//  UIView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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
- (nullable UIImage *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates;

/**
 * Returns the first responder of this view.
 */
- (nullable UIView *)findFirstResponder;

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
- (nullable UIView *)findSuperviewOf:(Class)viewClass;

/**
 * Searches in subviews recursively to find the view which its class is the given viewClass.
 */
- (nullable UIView *)findSubviewOf:(Class)viewClass;

/**
 * Returns the UIViewController instance which manages this view.
 */
- (nullable UIViewController *)viewController;

/**
 * Set layer.mask
 * http://stackoverflow.com/a/5826745
 */
- (CAShapeLayer *)setMaskLayerByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 * Set layer.mask, rounds all corners with the same horizontal and vertical radius
 * http://stackoverflow.com/a/5826745
 */
- (CAShapeLayer *)setMaskLayerWithCornerRadius:(CGFloat)cornerRadius;

/**
 * Set layer's shadow: https://stackoverflow.com/a/9761354/521946
 * Rounded corner + shadow: https://fluffy.es/rounded-corner-shadow/
 * Rounded corner + shadow: https://github.com/douglas-queiroz/UIViewWithRoundedCornersAndShadow/blob/master/UIViewWithRoundedCornersAndShadow/UIView+RoundedCorner+Shadow.m
 */
- (void)setLayerShadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

/// insert `CAGradientLayer` at index 0.
- (CAGradientLayer *)setGradientBackgroundColor:(UIColor *)startColor, ... NS_REQUIRES_NIL_TERMINATION;

/// insert `CAGradientLayer` at index 0.
- (CAGradientLayer *)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (void)enableDebugBorder;
- (void)enableDebugBorderWithColor:(UIColor *)color;

- (void)bringToFront;
- (void)sendToBack;
- (void)moveToCenterOfSuperview;

- (NSUInteger)indexOnSuperview;
- (BOOL)isInFrontOfSuperview;
- (BOOL)isAtBackOfSuperview;

@end

NS_ASSUME_NONNULL_END
