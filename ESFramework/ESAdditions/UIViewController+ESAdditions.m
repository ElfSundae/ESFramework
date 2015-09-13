//
//  UIViewController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/7/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIViewController+ESAdditions.h"

@implementation UIViewController (ESAdditions)

- (UIViewController *)previousViewController
{
        UINavigationController *navController = self.navigationController;
        if (navController) {
                NSArray *controllers = navController.viewControllers;
                if (0 == controllers.count) {
                        return nil;
                }
                NSUInteger index = [controllers indexOfObject:self];
                if (NSNotFound == index) {
                        return nil;
                }
                if (index > 0) {
                        return controllers[index - 1];
                }
        }
        return nil;
}

- (UIViewController *)nextViewController
{
        UINavigationController *navController = self.navigationController;
        if (navController) {
                NSArray *controllers = navController.viewControllers;
                if (0 == controllers.count) {
                        return nil;
                }
                NSUInteger index = [controllers indexOfObject:self];
                if (NSNotFound == index) {
                        return nil;
                }
                if ((index + 1) < controllers.count) {
                        return controllers[index + 1];
                }
        }
	
	return nil;
}

- (BOOL)isViewVisible
{
        return ([self isViewLoaded] && self.view.window != nil);
}

- (UIViewController *)currentVisibleViewController
{
        if ([self isKindOfClass:[UITabBarController class]]) {
                return [[(UITabBarController *)self selectedViewController] currentVisibleViewController];
        } else if ([self isKindOfClass:[UINavigationController class]]) {
                return [(UINavigationController *)self topViewController];
        }
        return self;
}

@end
