//
//  UIView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIView+ESAdditions.h"
#import "UIGestureRecognizer+ESAdditions.h"
#import "NSArray+ESAdditions.h"

@implementation UIView (ESAdditions)

- (UIView *)findFirstResponder
{
        if ([self isFirstResponder]) {
                return self;
        }
        
        for (UIView *subView in [self subviews]) {
                UIView *firstResponder = [subView findFirstResponder];
                if (nil != firstResponder) {
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

- (UIView *)findViewWithClassInSuperviews:(Class)viewClass
{
        if ([self.superview isKindOfClass:viewClass]) {
                return self.superview;
        } else if (self.superview) {
                return [self.superview findViewWithClassInSuperviews:viewClass];
        } else {
                return nil;
        }
}

- (UIView *)findViewWithClassInSubviews:(Class)viewClass
{
        UIView *foundView = nil;
        for (UIView *view in self.subviews) {
                if ([view isKindOfClass:viewClass]) {
                        foundView = view;
                        break;
                } else {
                        UIView *subview = [view findViewWithClassInSubviews:viewClass];
                        if (subview) {
                                foundView = subview;
                                break;
                        }
                }
        }
        return foundView;
}

- (UIViewController *)viewController
{
        UIViewController *controller = nil;
        UIView *view = self;
        UIResponder *nextResponder = nil;
        do {
                nextResponder = view.nextResponder;
                if ([nextResponder isKindOfClass:[UIViewController class]]) {
                        controller = (UIViewController *)nextResponder;
                        break;
                } else {
                        view = view.superview;
                }
                
        } while (view && controller == nil);
        return controller;
}

- (UITapGestureRecognizer *)addTapGestureHandler:(void (^)(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView))handler
{
        NSParameterAssert(handler);
        UITapGestureRecognizer *tap = [UITapGestureRecognizer recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
                if (UIGestureRecognizerStateRecognized == state) {
                        handler((UITapGestureRecognizer *)sender, sender.view, locationInView);
                }
        }];
        if (!self.isUserInteractionEnabled) {
                self.userInteractionEnabled = YES;
        }
        [self addGestureRecognizer:tap];
        return tap;
}

- (UILongPressGestureRecognizer *)addLongPressGestureHandler:(void (^)(UILongPressGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView))handler
{
        NSParameterAssert(handler);
        UILongPressGestureRecognizer *longPress = [UILongPressGestureRecognizer recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint locationInView) {
                if (UIGestureRecognizerStateBegan == state) {
                        handler((UILongPressGestureRecognizer *)sender, sender.view, locationInView);
                }
        }];
        if (!self.isUserInteractionEnabled) {
                self.userInteractionEnabled = YES;
        }
        [self addGestureRecognizer:longPress];
        return longPress;
}

- (NSArray *)allTapGestureRecognizers
{
        return [[self gestureRecognizers] matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj isKindOfClass:[UITapGestureRecognizer class]];
        }];
}
- (NSArray *)allLongPressGestureRecognizers
{
        return [[self gestureRecognizers] matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj isKindOfClass:[UILongPressGestureRecognizer class]];
        }];
}
- (NSArray *)allPanGestureRecognizers
{
        return [[self gestureRecognizers] matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj isKindOfClass:[UIPanGestureRecognizer class]];
        }];
}
- (NSArray *)allPinchGestureRecognizers
{
        return [[self gestureRecognizers] matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj isKindOfClass:[UIPinchGestureRecognizer class]];
        }];
}
- (NSArray *)allSwipeGestureRecognizers
{
        return [[self gestureRecognizers] matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj isKindOfClass:[UISwipeGestureRecognizer class]];
        }];
}
- (NSArray *)allRotationGestureRecognizers
{
        return [[self gestureRecognizers] matchesObjects:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj isKindOfClass:[UIRotationGestureRecognizer class]];
        }];
}

- (void)removeAllTapGestureRecognizers
{
        [[self allTapGestureRecognizers] each:^(id obj, NSUInteger idx, BOOL *stop) {
                [[(UIGestureRecognizer *)obj view] removeGestureRecognizer:obj];
        } option:NSEnumerationConcurrent];
}
- (void)removeAllLongPressGestureRecognizers
{
        [[self allLongPressGestureRecognizers] each:^(id obj, NSUInteger idx, BOOL *stop) {
                [[(UIGestureRecognizer *)obj view] removeGestureRecognizer:obj];
        } option:NSEnumerationConcurrent];
}
- (void)removeAllPanGestureRecognizers
{
        [[self allPanGestureRecognizers] each:^(id obj, NSUInteger idx, BOOL *stop) {
                [[(UIGestureRecognizer *)obj view] removeGestureRecognizer:obj];
        } option:NSEnumerationConcurrent];
}
- (void)removeAllPinchGestureRecognizers
{
        [[self allPinchGestureRecognizers] each:^(id obj, NSUInteger idx, BOOL *stop) {
                [[(UIGestureRecognizer *)obj view] removeGestureRecognizer:obj];
        } option:NSEnumerationConcurrent];
}
- (void)removeAllSwipeGestureRecognizers
{
        [[self allSwipeGestureRecognizers] each:^(id obj, NSUInteger idx, BOOL *stop) {
                [[(UIGestureRecognizer *)obj view] removeGestureRecognizer:obj];
        } option:NSEnumerationConcurrent];
}
- (void)removeAllRotationGestureRecognizers
{
        [[self allRotationGestureRecognizers] each:^(id obj, NSUInteger idx, BOOL *stop) {
                [[(UIGestureRecognizer *)obj view] removeGestureRecognizer:obj];
        } option:NSEnumerationConcurrent];
}

- (void)setMaskLayerByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = self.bounds;
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii].CGPath;
        self.layer.mask = maskLayer;
}

- (void)setMaskLayerWithCornerRadius:(CGFloat)cornerRadius
{
        [self setMaskLayerByRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
}

- (void)setCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = [borderColor CGColor];
}

- (void)setShadowOffset:(CGSize)offset radius:(CGFloat)radius opacity:(CGFloat)opacity
{
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = offset;
        self.layer.shadowRadius = radius;
        self.layer.shadowOpacity = opacity;
}

- (void)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.frame = self.bounds;
        gradient.colors = @[(id)[startColor CGColor], (id)[endColor CGColor]];
        
        [self.layer insertSublayer:gradient atIndex:0];
}

- (void)setBackgroundGradientColor:(UIColor *)startColor, ... NS_REQUIRES_NIL_TERMINATION
{
        if (startColor) {
                NSMutableArray *colors = [NSMutableArray array];
                va_list args;
                va_start(args, startColor);
                UIColor *color = startColor;
                do {
                        [colors addObject:(id)color.CGColor];
                } while ((color = va_arg(args, UIColor *)));
                va_end(args);
                
                CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = self.bounds;
                gradient.colors = colors;
                
                [self.layer insertSublayer:gradient atIndex:0];
        }
}

- (void)enableDebugBorderWithColor:(UIColor *)color
{
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 2.0;
}

- (void)enableDebugBorder
{
        [self enableDebugBorderWithColor:ESRandomColor()];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (NSUInteger)indexOnSuperview
{
        return [self.superview.subviews indexOfObject:self];
}

- (void)bringToFront
{
        [self.superview bringSubviewToFront:self];
}

- (void)sendToBack
{
        [self.superview sendSubviewToBack:self];
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

- (void)moveToCenterOfSuperview
{
        if (self.superview) {
                self.frame = CGRectMake((self.superview.bounds.size.width - self.frame.size.width) / 2.,
                                        (self.superview.bounds.size.height - self.frame.size.height) / 2.,
                                        self.frame.size.width,
                                        self.frame.size.height);
        }
}

@end
