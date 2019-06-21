//
//  UIToolbar+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import "UIToolbar+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import "NSArray+ESExtension.h"

@implementation UIToolbar (ESExtension)

- (nullable __kindof UIBarButtonItem *)itemWithTag:(NSInteger)tag
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

#endif
