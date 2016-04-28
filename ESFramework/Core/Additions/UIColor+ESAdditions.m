//
//  UIColor+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIColor+ESAdditions.h"
#import "ESDefines.h"

@implementation UIColor (ESAdditions)

- (NSString *)es_RGBString
{
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b alpha:NULL];
        return [NSString stringWithFormat:@"rgb(%lu,%lu,%lu)", lroundf(r * 255.), lroundf(g * 255.), lroundf(b * 255.)];
}

- (NSString *)es_RGBAString
{
        CGFloat r, g, b, a;
        [self getRed:&r green:&g blue:&b alpha:&a];
        return [NSString stringWithFormat:@"rgba(%lu,%lu,%lu,%g)", lroundf(r * 255.), lroundf(g * 255.), lroundf(b * 255.), a];
}

- (NSString *)es_HexString
{
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b alpha:NULL];
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255.), lroundf(g * 255.), lroundf(b * 255.)];
}

+ (UIColor *)es_iOS6GroupTableViewBackgroundColor
{
        static UIImage *__esGroupTableViewBackgroundImage = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(7., 1.), NO, 0.0);
                CGContextRef c = UIGraphicsGetCurrentContext();
                [[UIColor colorWithRed:185./255. green:192./255. blue:202./255. alpha:1.] setFill];
                CGContextFillRect(c, CGRectMake(0, 0, 4, 1));
                [[UIColor colorWithRed:185./255. green:193./255. blue:200./255. alpha:1.] setFill];
                CGContextFillRect(c, CGRectMake(4, 0, 1, 1));
                [[UIColor colorWithRed:192./255. green:200./255. blue:207./255. alpha:1.] setFill];
                CGContextFillRect(c, CGRectMake(5, 0, 2, 1));
                __esGroupTableViewBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
        });
        return [UIColor colorWithPatternImage:__esGroupTableViewBackgroundImage];
}

+ (UIColor *)es_viewBackgroundColor
{
        // 0.937255 0.937255 0.956863 1
        return [UIColor groupTableViewBackgroundColor];
}

+ (UIColor *)es_redNavigationBarColor
{
        return [UIColor colorWithRed:0.987 green:0.129 blue:0.146 alpha:1.000];
}

+ (UIColor *)es_blueNavigationBarColor
{
        return [UIColor colorWithRed:0.054 green:0.433 blue:0.925 alpha:1.000];
}

+ (UIColor *)es_blackNavigationBarColor
{
        return [UIColor colorWithWhite:0.090 alpha:1.000];
}

+ (UIColor *)es_lightBorderColor
{
        return [UIColor colorWithWhite:0.933 alpha:1.000];
}
+ (UIColor *)es_defaultButtonColor
{
        return [UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.000];
}
+ (UIColor *)es_primaryButtonColor
{
        return [UIColor colorWithRed:0.133 green:0.421 blue:0.668 alpha:1.000];
}
+ (UIColor *)es_infoButtonColor
{
        return [UIColor colorWithRed:0.300 green:0.697 blue:0.839 alpha:1.000];
}
+ (UIColor *)es_successButtonColor
{
        return [UIColor colorWithRed:0.167 green:0.716 blue:0.032 alpha:1.000];
}
+ (UIColor *)es_warningButtonColor
{
        return [UIColor colorWithRed:0.919 green:0.612 blue:0.238 alpha:1.000];
}
+ (UIColor *)es_dangerButtonColor
{
        return [UIColor colorWithRed:0.806 green:0.237 blue:0.241 alpha:1.000];
}
+ (UIColor *)es_twitterColor
{
        return [UIColor colorWithRed:0.25 green:0.60 blue:1.00 alpha:1.00];
}
+ (UIColor *)es_facebookColor
{
        return [UIColor colorWithRed:0.23 green:0.35 blue:0.60 alpha:1.00];
}

+ (UIColor *)es_purpleColor
{
        return [UIColor colorWithRed:0.45 green:0.30 blue:0.75 alpha:1.00];
}
+ (UIColor *)es_redColor
{
        return [UIColor colorWithRed:0.861 green:0.000 blue:0.021 alpha:1.000];
}
+ (UIColor *)es_orangeColor
{
        return [UIColor colorWithRed:0.991 green:0.509 blue:0.033 alpha:1.000];
}
+ (UIColor *)es_yellowColor
{
        return [UIColor colorWithRed:0.927 green:0.728 blue:0.064 alpha:1.000];
}
+ (UIColor *)es_oceanDarkColor
{
        return [UIColor colorWithRed:0.131 green:0.184 blue:0.246 alpha:1.000];
}


- (UIColor *)es_desaturatedColorToPercentSaturation:(CGFloat)percent
{
        CGFloat h, s, b, a;
        [self getHue:&h saturation:&s brightness:&b alpha:&a];
        return [UIColor colorWithHue:h saturation:s * percent brightness:b alpha:a];
}

- (UIColor *)es_lightenColorWithValue:(CGFloat)value
{
        NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
        BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
        
        CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
        CGFloat newComponents[4];
        
        if(isGreyscale) {
                newComponents[0] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
                newComponents[1] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
                newComponents[2] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
                newComponents[3] = oldComponents[1];
        }
        else {
                newComponents[0] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
                newComponents[1] = oldComponents[1] + value > 1.0 ? 1.0 : oldComponents[1] + value;
                newComponents[2] = oldComponents[2] + value > 1.0 ? 1.0 : oldComponents[2] + value;
                newComponents[3] = oldComponents[3];
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
        CGColorSpaceRelease(colorSpace);
        
        UIColor *retColor = [UIColor colorWithCGColor:newColor];
        CGColorRelease(newColor);
        
        return retColor;
}

- (UIColor *)es_darkenColorWithValue:(CGFloat)value
{
        NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
        BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
        
        CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
        CGFloat newComponents[4];
        
        if(isGreyscale) {
                newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
                newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
                newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
                newComponents[3] = oldComponents[1];
        }
        else {
                newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
                newComponents[1] = oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value;
                newComponents[2] = oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value;
                newComponents[3] = oldComponents[3];
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
        CGColorSpaceRelease(colorSpace);
        
        UIColor *retColor = [UIColor colorWithCGColor:newColor];
        CGColorRelease(newColor);
        
        return retColor;
}

- (BOOL)es_isLightColor
{
        NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
        BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
        
        CGFloat *components = (CGFloat *)CGColorGetComponents(self.CGColor);
        CGFloat sum;
        
        if(isGreyscale) {
                sum = components[0];
        }
        else {
                sum = (components[0] + components[1] + components[2]) / 3.0;
        }
        
        return (sum >= 0.75);
}

@end
