//
//  UIView+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/06.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ESExtension)

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
- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

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
- (nullable __kindof UIView *)findSuperviewOfClass:(Class)viewClass;

/**
 * Searches in subviews recursively to find the view which its class is the given viewClass.
 */
- (nullable __kindof UIView *)findSubviewOfClass:(Class)viewClass;

/**
 * Returns the UIViewController instance which manages this view.
 */
- (nullable __kindof UIViewController *)viewController;

/**
 * Adds and returns a tap gesture recognizer.
 */
- (__kindof UITapGestureRecognizer *)addTapGestureRecognizerWithBlock:(void (^)(__kindof UITapGestureRecognizer *tap))block;

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
- (void)setLayerShadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity;

/// insert `CAGradientLayer` at index 0.
- (CAGradientLayer *)setGradientBackgroundColor:(UIColor *)startColor, ... NS_REQUIRES_NIL_TERMINATION;

/// insert `CAGradientLayer` at index 0.
- (CAGradientLayer *)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (void)enableDebugBorder;
- (void)enableDebugBorderWithColor:(UIColor *)color;

- (void)bringToFront;
- (void)sendToBack;
- (void)moveSubviewToCenter:(UIView *)view;
- (void)moveToCenter;

- (NSUInteger)indexOnSuperview;
- (BOOL)isInFrontOfSuperview;
- (BOOL)isAtBackOfSuperview;

@end

NS_ASSUME_NONNULL_END

#endif
