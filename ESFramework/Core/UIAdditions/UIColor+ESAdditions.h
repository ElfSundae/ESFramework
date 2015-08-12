//
//  UIColor+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ESAdditions)

/// @"rgb(239,156,255)"
- (NSString *)es_RGBString;
/// @"rgba(239,156,255,0.5)"
- (NSString *)es_RGBAString;
/// @"#EF9CFF"
- (NSString *)es_HexString;
/// take groupTableViewBackgroundColor back on iOS6+
+ (UIColor *)es_groupTableViewBackgroundColor;

// Utilities from [BButton](https://github.com/jessesquires/BButton)
- (UIColor *)es_desaturatedColorToPercentSaturation:(CGFloat)percent;
- (UIColor *)es_lightenColorWithValue:(CGFloat)value;
- (UIColor *)es_darkenColorWithValue:(CGFloat)value;
- (BOOL)es_isLightColor;

@end