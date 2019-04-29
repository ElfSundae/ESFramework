//
//  UITabBarController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2017/01/04.
//  Copyright © 2017年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (ESAdditions)

- (BOOL)pushViewController:(UIViewController *)viewController atTabIndex:(NSUInteger)tabIndex fromRoot:(BOOL)fromRoot popCurrentViewControllerToRoot:(BOOL)popCurrentToRoot animated:(BOOL)animated;

- (BOOL)pushViewController:(UIViewController *)viewController atTabIndex:(NSUInteger)tabIndex fromRoot:(BOOL)fromRoot;

@end

NS_ASSUME_NONNULL_END
