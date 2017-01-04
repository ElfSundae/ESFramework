//
//  UITabBarController+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2017/01/04.
//  Copyright © 2017年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (ESAdditions)

/**
 * Set badge value for tab bar item at the given index.
 */
- (void)setBadgeValue:(NSString *)badgeValue forTabBarItemAtIndex:(NSUInteger)index;

@end
