//
//  UIViewController+ESStatusOverlayView.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIViewController+ESStatusOverlayView.h"
#import <ESFramework/ESDefines.h>

static const void *_esStatusOverlayViewKey = &_esStatusOverlayViewKey;

@implementation UIViewController (ESStatusOverlayView)

- (ESStatusOverlayView *)statusOverlayView
{
        ESStatusOverlayView *v = ESGetAssociatedObject(self, _esStatusOverlayViewKey);
        if (!v) {
                v = [[ESStatusOverlayView alloc] initWithView:self.view];
                [self setStatusOverlayView:v];
        }
        return v;
}

- (void)setStatusOverlayView:(ESStatusOverlayView *)statusOverlayView
{
        ESSetAssociatedObject(self, _esStatusOverlayViewKey, statusOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowingStatusOverlayView
{
        ESStatusOverlayView *v = ESGetAssociatedObject(self, _esStatusOverlayViewKey);
        return (v && !v.isHidden);
}

@end
