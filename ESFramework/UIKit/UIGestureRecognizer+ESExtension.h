//
//  UIGestureRecognizer+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (ESExtension)

/**
 * Creates a new gesture-recognizer object with an optional action block.
 */
- (instancetype)initWithActionBlock:(void (^ _Nullable)(__kindof UIGestureRecognizer *gestureRecognizer))actionBlock;

/**
 * Adds an action block to the gesture-recognizer object.
 */
- (void)addActionBlock:(void (^)(__kindof UIGestureRecognizer *gestureRecognizer))actionBlock;

/**
 * Removes all action blocks for the gesture-recognizer object.
 */
- (void)removeAllActionBlocks;

@end

NS_ASSUME_NONNULL_END

#endif
