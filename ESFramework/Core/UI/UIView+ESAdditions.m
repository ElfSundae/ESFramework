//
//  UIView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIView+ESAdditions.h"
#import "UIGestureRecognizer+ESAdditions.h"
#import "UIColor+ESAdditions.h"

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
        UIView *childView = nil;
        while ((childView = self.subviews.lastObject)) {
                [childView removeFromSuperview];
        }
}

- (UIView *)findViewWithClass:(Class)class_ shouldSearchInSuperview:(BOOL)shouldSearchInSuperview
{
        if ([self isKindOfClass:class_]) {
                return self;
        }
        if (shouldSearchInSuperview) {
                if (self.superview) {
                        return [self.superview findViewWithClass:class_ shouldSearchInSuperview:YES];
                }
        } else {
                for (UIView *v in self.subviews) {
                        UIView *child = [v findViewWithClass:class_ shouldSearchInSuperview:NO];
                        if (child) {
                                return child;
                        }
                }
        }
        return nil;
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
        [self enableDebugBorderWithColor:[UIColor randomColor]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

- (NSUInteger)indexOfSuperview
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
                self.frame = ESFrameOfCenteredViewWithinView(self, self.superview);
        }
}

@end
