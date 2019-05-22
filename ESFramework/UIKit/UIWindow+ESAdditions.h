//
//  UIWindow+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/22.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (ESAdditions)

/**
 * Returns the topmost view controller in window's hierarchy.
 */
- (nullable UIViewController *)topmostViewController;

@end

NS_ASSUME_NONNULL_END
