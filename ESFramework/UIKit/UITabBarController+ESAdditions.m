//
//  UITabBarController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2017/01/04.
//  Copyright © 2017年 www.0x123.com. All rights reserved.
//

#import "UITabBarController+ESAdditions.h"

@implementation UITabBarController (ESAdditions)

- (BOOL)pushViewController:(UIViewController *)viewController atTabIndex:(NSUInteger)tabIndex fromRoot:(BOOL)fromRoot popCurrentViewControllerToRoot:(BOOL)popCurrentToRoot animated:(BOOL)animated
{
    if (tabIndex >= self.viewControllers.count) {
        return NO;
    }

    if (![self.viewControllers[tabIndex] isKindOfClass:[UINavigationController class]]) {
        return NO;
    }

    UINavigationController *navController = (UINavigationController *)self.viewControllers[tabIndex];

    if (fromRoot) {
        [navController popToRootViewControllerAnimated:NO];
    }

    if (tabIndex != self.selectedIndex) {
        if (popCurrentToRoot && [self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
        }

        self.selectedIndex = tabIndex;
    }

    [navController pushViewController:viewController animated:animated];

    return YES;
}

- (BOOL)pushViewController:(UIViewController *)viewController atTabIndex:(NSUInteger)tabIndex fromRoot:(BOOL)fromRoot
{
    return [self pushViewController:viewController atTabIndex:tabIndex fromRoot:fromRoot popCurrentViewControllerToRoot:YES animated:YES];
}

@end
