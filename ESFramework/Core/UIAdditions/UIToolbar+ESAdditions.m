//
//  UIToolbar+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIToolbar+ESAdditions.h"
#import "NSArray+ESAdditions.h"
#import "ESDefines.h"
ES_CATEGORY_FIX(UIToolbar_ESAdditions)

@implementation UIToolbar (ESAdditions)

- (UIBarButtonItem *)itemWithTag:(NSInteger)tag
{
        for (UIBarButtonItem *item in self.items) {
                if (item.tag == tag) {
                        return item;
                }
        }
        return nil;
}

- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem *)newItem
{
        UIBarButtonItem *item = [self itemWithTag:tag];
        if (item) {
                NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
                [newItems replaceObject:item withObject:newItems];
                self.items = newItems;
        }
}


@end
