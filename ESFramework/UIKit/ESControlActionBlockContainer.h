//
//  ESControlActionBlockContainer.h
//  ESFramework
//
//  Created by Elf Sundae on 2020/06/17.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>
#import "ESActionBlockContainer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A container object holds an action block and associated UIControl events types.
 */
@interface ESControlActionBlockContainer : ESActionBlockContainer

/**
 * The associated UIControl events types for the action block.
 */
@property (nonatomic) UIControlEvents controlEvents;

/**
 * Creates a new action-block container object.
 */
- (instancetype)initWithBlock:(void (^ _Nullable)(id sender))block controlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END

#endif
