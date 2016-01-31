//
//  UIViewController+ESStatusOverlayView.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIViewController+ESStatusOverlayView.h"
#import <ESFramework/ESDefines.h>

ESDefineAssociatedObjectKey(statusOverlayView);

@implementation UIViewController (ESStatusOverlayView)

- (ESStatusOverlayView *)currentStatusOverlayView
{
        return ESGetAssociatedObject(self, statusOverlayViewKey);
}

- (ESStatusOverlayView *)statusOverlayView
{
        ESStatusOverlayView *view = [self currentStatusOverlayView];
        if (!view) {
                view = [[ESStatusOverlayView alloc] initWithView:self.view];
                [self setStatusOverlayView:view];
        }
        return view;
}

- (void)setStatusOverlayView:(ESStatusOverlayView *)view
{
        ESSetAssociatedObject(self, statusOverlayViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowingStatusOverlayView
{
        ESStatusOverlayView *view = [self currentStatusOverlayView];
        return (view && !view.isHidden);
}

@end
