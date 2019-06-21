//
//  UIView+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/06.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import "UIView+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import "UIColor+ESExtension.h"
#import "UIGestureRecognizer+ESExtension.h"

@implementation UIView (ESExtension)

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (nullable UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates
{
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, UIScreen.mainScreen.scale);
    if ([self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates]) {
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}

- (nullable UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }

    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }

    return nil;
}

- (BOOL)findAndResignFirstResponder
{
    UIView *found = [self findFirstResponder];
    if (found) {
        return [found resignFirstResponder];
    }
    return NO;
}

- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (nullable __kindof UIView *)findSuperviewOfClass:(Class)viewClass
{
    if ([self.superview isKindOfClass:viewClass]) {
        return self.superview;
    } else if (self.superview) {
        return [self.superview findSuperviewOfClass:viewClass];
    } else {
        return nil;
    }
}

- (nullable __kindof UIView *)findSubviewOfClass:(Class)viewClass
{
    UIView *foundView = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewClass]) {
            foundView = view;
            break;
        } else {
            UIView *subview = [view findSubviewOfClass:viewClass];
            if (subview) {
                foundView = subview;
                break;
            }
        }
    }
    return foundView;
}

- (nullable __kindof UIViewController *)viewController
{
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = view.nextResponder;
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }

    return nil;
}

- (__kindof UITapGestureRecognizer *)addTapGestureRecognizerWithBlock:(void (^)(__kindof UITapGestureRecognizer *tap))block
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer *gestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            block(gestureRecognizer);
        }
    }];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
    return tap;
}

- (CAShapeLayer *)setMaskLayerByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                           byRoundingCorners:corners
                                                 cornerRadii:cornerRadii].CGPath;
    return self.layer.mask = maskLayer;
}

- (CAShapeLayer *)setMaskLayerWithCornerRadius:(CGFloat)cornerRadius
{
    return [self setMaskLayerByRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
}

- (void)setLayerShadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity
{
    self.layer.masksToBounds = NO;
    if (color) self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (CAGradientLayer *)setGradientBackgroundColor:(UIColor *)startColor, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *colors = [NSMutableArray array];
    va_list args;
    va_start(args, startColor);
    UIColor *color = startColor;
    do {
        [colors addObject:(id)color.CGColor];
    } while ((color = va_arg(args, UIColor *)));
    va_end(args);

    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = [colors copy];
    [self.layer insertSublayer:layer atIndex:0];
    return layer;
}

- (CAGradientLayer *)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    return [self setGradientBackgroundColor:startColor, endColor, nil];
}

- (void)enableDebugBorder
{
    [self enableDebugBorderWithColor:[UIColor randomColor]];
}

- (void)enableDebugBorderWithColor:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 2.0;
}

- (void)bringToFront
{
    [self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
    [self.superview sendSubviewToBack:self];
}

- (void)moveSubviewToCenter:(UIView *)view
{
    view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)moveToCenter
{
    [self.superview moveSubviewToCenter:self];
}

- (NSUInteger)indexOnSuperview
{
    return [self.superview.subviews indexOfObject:self];
}

- (BOOL)isInFrontOfSuperview
{
    if (!self.superview) {
        return NO;
    }
    return self.superview.subviews.lastObject == self;
}

- (BOOL)isAtBackOfSuperview
{
    if (!self.superview) {
        return NO;
    }
    return self.superview.subviews.firstObject == self;
}

@end

#endif
