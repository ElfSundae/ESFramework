//
//  UIToolbar+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIToolbar (ESAdditions)

- (nullable __kindof UIBarButtonItem *)itemWithTag:(NSInteger)tag;
- (void)replaceItemWithTag:(NSInteger)tag toItem:(UIBarButtonItem *)newItem animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
