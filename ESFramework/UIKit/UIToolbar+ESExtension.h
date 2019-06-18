//
//  UIToolbar+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIToolbar (ESExtension)

- (nullable __kindof UIBarButtonItem *)itemWithTag:(NSInteger)tag;
- (void)replaceItemWithTag:(NSInteger)tag toItem:(UIBarButtonItem *)newItem animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

#endif
