//
//  UIControl+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/24.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (ESExtension)

/**
 * Associates an action block with the control.
 */
- (void)addActionBlock:(void (^)(__kindof UIControl *control))actionBlock forControlEvents:(UIControlEvents)controlEvents;

/**
 * Replaces the action block of the control events to a new block or \c nil which
 * will remove the existing block of the events.
 */
- (void)setActionBlock:(void (^ _Nullable)(__kindof UIControl *control))actionBlock forControlEvents:(UIControlEvents)controlEvents;

/**
 * Removes all action blocks for the given control events.
 */
- (void)removeAllActionBlocksForControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END

#endif
