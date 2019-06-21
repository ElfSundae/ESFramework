//
//  UIWindow+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/22.
//  Copyright © 2019 https://0x123.com All rights reserved.
//

#import "UIWindow+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

@implementation UIWindow (ESExtension)

- (nullable __kindof UIViewController *)topmostViewController
{
    UIViewController *viewController = self.rootViewController;

    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }

    return viewController;
}

@end

#endif
