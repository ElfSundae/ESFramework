//
//  UIToolbar+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIToolbar+ESAdditions.h"
#import "NSArray+ESAdditions.h"

@implementation UIToolbar (ESAdditions)

- (nullable UIBarButtonItem *)itemWithTag:(NSInteger)tag
{
    for (UIBarButtonItem *item in self.items) {
        if (tag == item.tag) {
            return item;
        }
    }
    return nil;
}

- (void)replaceItemWithTag:(NSInteger)tag toItem:(UIBarButtonItem *)newItem animated:(BOOL)animated
{
    UIBarButtonItem *item = [self itemWithTag:tag];
    if (item) {
        NSMutableArray *newItems = self.items.mutableCopy;
        [newItems replaceObject:item withObject:newItem];
        [self setItems:newItems animated:animated];
    }
}

@end
