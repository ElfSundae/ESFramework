//
//  UIView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIView+ESAdditions.h"
#import "UIGestureRecognizer+ESAdditions.h"

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
@end
