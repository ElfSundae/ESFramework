//
//  UIBarButtonItem+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2019 www.0x123.com. All rights reserved.
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

@end

NS_ASSUME_NONNULL_END

#endif
