//
//  UIScrollView+ESRefreshControl.m
//  ESFramework
//
//  Created by Elf Sundae on 5/23/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESRefreshControl.h"
#import "ESDefines.h"

static const void *_esRefreshControlKey = &_esRefreshControlKey;

@implementation UIScrollView (ESRefreshControl)

- (ESRefreshControl *)refreshControl
{
        return ESGetAssociatedObject(self, _esRefreshControlKey);
}

- (void)setRefreshControl:(ESRefreshControl *)refreshControl
{
        ESRefreshControl *control = [self refreshControl];
        if (control) {
                [control removeFromSuperview];
        }
        if (refreshControl) {
                [self addSubview:refreshControl];
        }
        ESSetAssociatedObject(self, _esRefreshControlKey, refreshControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
