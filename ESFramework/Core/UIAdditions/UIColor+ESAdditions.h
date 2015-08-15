//
//  UIColor+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// Color Picker Websites:
// http://tintui.com
// https://flatuicolors.com
// http://flatcolors.net
// http://www.flatuicolorpicker.com
// http://bootflat.github.io/color-picker.html


@interface UIColor (ESAdditions)

/// @"rgb(239,156,255)"
- (NSString *)es_RGBString;
/// @"rgba(239,156,255,0.5)"
- (NSString *)es_RGBAString;
/// @"#EF9CFF"
- (NSString *)es_HexString;

/// take groupTableViewBackgroundColor back on iOS6+
+ (UIColor *)es_groupTableViewBackgroundColor;
/// [UIColor colorWithRed:0.937 green:0.937 blue:0.957 alpha:1.000]
+ (UIColor *)es_viewBackgroundColor;

+ (UIColor *)es_redNavigationBarColor;
+ (UIColor *)es_blueNavigationBarColor;
+ (UIColor *)es_blackNavigationBarColor;

/// [UIColor colorWithWhite:0.933 alpha:1.000]
+ (UIColor *)es_lightBorderColor;

/// [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.000]
+ (UIColor *)es_defaultButtonColor;
/// [UIColor colorWithRed:0.133 green:0.421 blue:0.668 alpha:1.000]
+ (UIColor *)es_primaryButtonColor;
/// [UIColor colorWithRed:0.300 green:0.697 blue:0.839 alpha:1.000]
+ (UIColor *)es_infoButtonColor;
/// [UIColor colorWithRed:0.303 green:0.678 blue:0.289 alpha:1.000]
+ (UIColor *)es_successButtonColor;
/// [UIColor colorWithRed:0.919 green:0.612 blue:0.238 alpha:1.000]
+ (UIColor *)es_warningButtonColor;
/// [UIColor colorWithRed:0.805 green:0.235 blue:0.241 alpha:1.000]
+ (UIColor *)es_dangerButtonColor;

/// [UIColor colorWithRed:0.25f green:0.60f blue:1.00f alpha:1.00f]
+ (UIColor *)es_twitterColor;
/// [UIColor colorWithRed:0.23f green:0.35f blue:0.60f alpha:1.00f]
+ (UIColor *)es_facebookColor;

/// [UIColor colorWithRed:0.45f green:0.30f blue:0.75f alpha:1.00f]
+ (UIColor *)es_purpleColor;
/// [UIColor colorWithRed:0.861 green:0.000 blue:0.021 alpha:1.000]
+ (UIColor *)es_redColor;
/// [UIColor colorWithRed:0.991 green:0.509 blue:0.033 alpha:1.000]
+ (UIColor *)es_orangeColor;
/// [UIColor colorWithRed:0.927 green:0.728 blue:0.064 alpha:1.000]
+ (UIColor *)es_yellowColor;
/// [UIColor colorWithRed:0.131 green:0.184 blue:0.246 alpha:1.000]
+ (UIColor *)es_oceanDarkColor;

// Utilities from [BButton](https://github.com/jessesquires/BButton)
- (UIColor *)es_desaturatedColorToPercentSaturation:(CGFloat)percent;
- (UIColor *)es_lightenColorWithValue:(CGFloat)value;
- (UIColor *)es_darkenColorWithValue:(CGFloat)value;
- (BOOL)es_isLightColor;

@end