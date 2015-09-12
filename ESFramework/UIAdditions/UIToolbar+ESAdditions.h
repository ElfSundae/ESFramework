//
//  UIToolbar+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (ESAdditions)
- (UIBarButtonItem *)itemWithTag:(NSInteger)tag;
- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem *)newItem;
@end
