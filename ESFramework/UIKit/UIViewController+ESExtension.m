//
//  UIViewController+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIViewController+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import "NSArray+ESExtension.h"

@implementation UIViewController (ESExtension)

- (nullable UIViewController *)previousViewController
{
    return [self.navigationController.viewControllers previousObjectToObject:self];
}

- (nullable UIViewController *)nextViewController
{
    return [self.navigationController.viewControllers nextObjectToObject:self];
}

- (BOOL)isViewVisible
{
    return self.isViewLoaded && self.view.window;
}

@end

#endif
