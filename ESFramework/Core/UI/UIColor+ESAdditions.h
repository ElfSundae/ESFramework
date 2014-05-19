//
//  UIColor+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @ref [BButton](https://github.com/jessesquires/BButton)
 */
@interface UIColor (ESAdditions)
/// @"rgb(239, 156, 255)"
- (NSString *)rgbString;
/// rgb(239, 156, 255, 0.5)
- (NSString *)rgbaString;
/// `#EF9CFF`
- (NSString *)hexString;
/// `#EF9CFF`
/// @see -[UIColor hexString]
- (NSString *)stringValue;
/// Returns a random color
+ (UIColor *)randomColor;

///=============================================
/// @name Useful color
///=============================================

+ (UIColor *)esGroupTableViewBackgroundColor;

///=============================================
/// @name BButton
///=============================================

- (BOOL)isLightColor;
- (UIColor *)desaturatedColorToPercentSaturation:(CGFloat)percent;
- (UIColor *)lightenColorWithValue:(CGFloat)value;
- (UIColor *)darkenColorWithValue:(CGFloat)value;
@end