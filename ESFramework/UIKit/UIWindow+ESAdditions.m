//
//  UIWindow+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/22.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIWindow+ESAdditions.h"

@implementation UIWindow (ESAdditions)

- (nullable UIViewController *)topMostViewController
{
    UIViewController *viewController = self.rootViewController;

    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }

    return viewController;
}

@end
