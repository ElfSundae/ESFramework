//
//  UIBarButtonItem+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (ESAdditions)
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithRedStyle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithDoneStyle:(NSString *)title target:(id)target action:(SEL)action;
@end
