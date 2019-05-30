//
//  UIColor+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// Color pickers:
// https://briangrinstead.com/blog/ios-uicolor-picker
// http://tintui.com
// https://flatuicolors.com
// http://www.flatuicolorpicker.com
// http://bootflat.github.io/color-picker.html

@interface UIColor (ESExtension)

/// e.g. "rgba(239,156,255,0.5)"
- (nullable NSString *)RGBAString;

/// e.g. "#EF9CFF"
- (nullable NSString *)RGBHexString;

+ (UIColor *)es_redNavigationBarColor;
+ (UIColor *)es_blueNavigationBarColor;
+ (UIColor *)es_blackNavigationBarColor;

+ (UIColor *)es_lightBorderColor;

// Twitter Bootstrap Buttons Color

+ (UIColor *)es_defaultButtonColor;
+ (UIColor *)es_primaryButtonColor;
+ (UIColor *)es_infoButtonColor;
+ (UIColor *)es_successButtonColor;
+ (UIColor *)es_warningButtonColor;
+ (UIColor *)es_dangerButtonColor;
+ (UIColor *)es_inverseButtonColor;

+ (UIColor *)es_twitterColor;
+ (UIColor *)es_facebookColor;
+ (UIColor *)es_purpleColor;
+ (UIColor *)es_redColor;
+ (UIColor *)es_orangeColor;
+ (UIColor *)es_yellowColor;
+ (UIColor *)es_oceanDarkColor;

/// Utilities from [BButton](https://github.com/jessesquires/BButton)
- (nullable UIColor *)es_desaturatedColorToPercentSaturation:(CGFloat)percent;
- (UIColor *)es_lightenColorWithValue:(CGFloat)value;
- (UIColor *)es_darkenColorWithValue:(CGFloat)value;
- (BOOL)es_isLightColor;

@end

NS_ASSUME_NONNULL_END
