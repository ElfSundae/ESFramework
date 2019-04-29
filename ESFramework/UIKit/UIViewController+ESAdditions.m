//
//  UIViewController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIViewController+ESAdditions.h"
#import "NSArray+ESAdditions.h"

@implementation UIViewController (ESAdditions)

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
    return self.isViewLoaded && self.view.window != nil;
}

@end
