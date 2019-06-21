//
//  UIColor+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/16.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ESExtension)

/**
 * Creates a random color.
 */
+ (UIColor *)randomColor;

/**
 * e.g. "rgba(239,156,255,0.5)"
 */
- (nullable NSString *)RGBAString;

/**
 * e.g. "#EF9CFF"
 */
- (nullable NSString *)RGBHexString;

@end

NS_ASSUME_NONNULL_END

#endif
