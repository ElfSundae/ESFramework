//
//  UIGestureRecognizer+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (ESAdditions)

- (instancetype)initWithActionBlock:(void (^ _Nullable)(__kindof UIGestureRecognizer *gr))actionBlock;

- (void)addActionBlock:(void (^)(__kindof UIGestureRecognizer *gr))actionBlock;
- (void)removeAllActionBlocks;

@end

NS_ASSUME_NONNULL_END
