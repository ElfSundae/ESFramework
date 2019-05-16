//
//  UIScrollView+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/16.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (ESAdditions)

- (void)scrollToTop:(BOOL)animated;
- (void)scrollToBottom:(BOOL)animated;
- (void)scrollToLeft:(BOOL)animated;
- (void)scrollToRight:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
