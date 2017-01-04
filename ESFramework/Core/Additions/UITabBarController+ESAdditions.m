//
//  UITabBarController+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2017/01/04.
//  Copyright © 2017年 www.0x123.com. All rights reserved.
//

#import "UITabBarController+ESAdditions.h"

@implementation UITabBarController (ESAdditions)

- (void)setBadgeValue:(NSString *)badgeValue forTabBarItemAtIndex:(NSUInteger)index
{
    if (index < self.tabBar.items.count) {
        [self.tabBar.items[index] setBadgeValue:badgeValue];
    }
}

@end
