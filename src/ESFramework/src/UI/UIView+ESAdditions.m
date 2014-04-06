//
//  UIView+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "UIView+ESAdditions.h"

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

@end
