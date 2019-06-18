//
//  ESActionBlockContainer.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * A container object holds an action block.
 * @discussion See `UIBarButtonItem+ESExtension` `UIGestureRecognizer+ESExtension`
 * `UIControl+ESExtension` for usage.
 */
@interface ESActionBlockContainer : NSObject

/**
 * The block which will be invoked as action handler.
 */
@property (nullable, nonatomic, copy) void (^block)(id sender);

/**
 * The selector of the -invoke method.
 */
@property (nonatomic, readonly) SEL action;

/**
 * Creates a new action-block container object.
 */
- (instancetype)initWithBlock:(void (^ _Nullable)(id sender))block;

/**
 * Invokes the action block.
 */
- (void)invoke:(id)sender;

@end

NS_ASSUME_NONNULL_END
