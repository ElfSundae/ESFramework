//
//  UINavigationController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UINavigationController+ESAdditions.h"
#import "ESHelpers.h"

@implementation UINavigationController (ESAdditions)

+ (void)load
{
    ESSwizzleInstanceMethod(self, @selector(preferredStatusBarStyle), @selector(_es_preferredStatusBarStyle));
    ESSwizzleInstanceMethod(self, @selector(preferredStatusBarUpdateAnimation), @selector(_es_preferredStatusBarUpdateAnimation));
    ESSwizzleInstanceMethod(self, @selector(prefersStatusBarHidden), @selector(_es_prefersStatusBarHidden));
    ESSwizzleInstanceMethod(self, @selector(shouldAutorotate), @selector(_es_shouldAutorotate));
    ESSwizzleInstanceMethod(self, @selector(supportedInterfaceOrientations), @selector(_es_supportedInterfaceOrientations));
    ESSwizzleInstanceMethod(self, @selector(preferredInterfaceOrientationForPresentation), @selector(_es_preferredInterfaceOrientationForPresentation));
}

- (UIStatusBarStyle)_es_preferredStatusBarStyle
{
    return self.viewControllers.lastObject.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)_es_preferredStatusBarUpdateAnimation
{
    return self.viewControllers.lastObject.preferredStatusBarUpdateAnimation;
}

- (BOOL)_es_prefersStatusBarHidden
{
    return self.viewControllers.lastObject.prefersStatusBarHidden;
}

- (BOOL)_es_shouldAutorotate
{
    return self.viewControllers.lastObject.shouldAutorotate;
}

- (NSUInteger)_es_supportedInterfaceOrientations
{
    return self.viewControllers.lastObject.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)_es_preferredInterfaceOrientationForPresentation
{
    return self.viewControllers.lastObject.preferredInterfaceOrientationForPresentation;
}

@end
