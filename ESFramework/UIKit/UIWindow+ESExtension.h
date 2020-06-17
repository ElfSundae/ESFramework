//
//  UIWindow+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/22.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ESExtension)

/**
 * Returns the top-most view controller in window's hierarchy.
 */
- (nullable __kindof UIViewController *)topmostViewController;

@end

NS_ASSUME_NONNULL_END

#endif
