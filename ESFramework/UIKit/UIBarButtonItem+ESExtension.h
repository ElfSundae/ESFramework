//
//  UIBarButtonItem+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (ESExtension)

/**
 * The action block that will be invoked when the user taps this bar button item.
 * @warning The `actionBlock` is conflict with `target` and `action` properties.
 */
@property (nullable, nonatomic, copy) void (^actionBlock)(__kindof UIBarButtonItem *buttonItem);

/**
 * Initializes a new item using the specified image and the action block.
 */
- (instancetype)initWithImage:(nullable UIImage *)image style:(UIBarButtonItemStyle)style actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock;

/**
 * Initializes a new item using the specified image and the action block.
 */
- (instancetype)initWithImage:(nullable UIImage *)image landscapeImagePhone:(nullable UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock;

/**
 * Initializes a new item using the specified title and the action block.
 */
- (instancetype)initWithTitle:(nullable NSString *)title style:(UIBarButtonItemStyle)style actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock;

/**
 * Initializes a new item containing the specified system item.
 */
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem actionBlock:(void (^)(__kindof UIBarButtonItem *buttonItem))actionBlock;

@end

NS_ASSUME_NONNULL_END

#endif
