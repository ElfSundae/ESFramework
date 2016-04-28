//
//  UIViewController+ESStatusOverlayView.m
//  ESFramework
//
//  Created by Elf Sundae on 5/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIViewController+ESStatusOverlayView.h"
#import "ESDefines.h"

ESDefineAssociatedObjectKey(statusOverlayView);

@implementation UIViewController (ESStatusOverlayView)

- (ESStatusOverlayView *)statusOverlayView
{
        return ESGetAssociatedObject(self, statusOverlayViewKey);
}

- (void)setStatusOverlayView:(ESStatusOverlayView *)view
{
        ESSetAssociatedObject(self, statusOverlayViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
