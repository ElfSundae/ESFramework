//
//  UIBarButtonItem+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-7.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "UIBarButtonItem+ESAdditions.h"

@implementation UIBarButtonItem (ESAdditions)

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title tintColor:(UIColor *)tintColor target:(id)target action:(SEL)action
{
        UIBarButtonItem *item = [[[self class] alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:target action:action];
        item.tintColor = tintColor;
        return item;
}

+ (UIBarButtonItem *)itemWithRedStyle:(NSString *)title target:(id)target action:(SEL)action
{
        return [self itemWithTitle:title tintColor:UIColorWithRGBHex(0xfa140e) target:target action:action];
}

+ (UIBarButtonItem *)itemWithDoneStyle:(NSString *)title target:(id)target action:(SEL)action
{
        return [[[self class] alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action];
}


@end
