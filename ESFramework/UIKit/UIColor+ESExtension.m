//
//  UIColor+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIColor+ESExtension.h"

@implementation UIColor (ESExtension)

+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:(CGFloat)arc4random() / UINT_MAX
                           green:(CGFloat)arc4random() / UINT_MAX
                            blue:(CGFloat)arc4random() / UINT_MAX
                           alpha:1.0];
}

- (nullable NSString *)RGBAString
{
    CGFloat r, g, b, a;
    return [self getRed:&r green:&g blue:&b alpha:&a]
           ? [NSString stringWithFormat:@"rgba(%lu,%lu,%lu,%g)", lroundf(r * 255.), lroundf(g * 255.), lroundf(b * 255.), a]
           : nil;
}

- (nullable NSString *)RGBHexString
{
    CGFloat r, g, b;
    return [self getRed:&r green:&g blue:&b alpha:NULL]
           ? [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255.), lroundf(g * 255.), lroundf(b * 255.)]
           : nil;
}

- (nullable UIColor *)es_desaturatedColorToPercentSaturation:(CGFloat)percent
{
    CGFloat h, s, b, a;
    return [self getHue:&h saturation:&s brightness:&b alpha:&a]
           ? [UIColor colorWithHue:h saturation:s * percent brightness:b alpha:a]
           : nil;
}

- (UIColor *)es_lightenColorWithValue:(CGFloat)value
{
    NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
    BOOL isGreyscale = (totalComponents == 2) ? YES : NO;

    CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
    CGFloat newComponents[4];

    if (isGreyscale) {
        newComponents[0] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
        newComponents[1] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
        newComponents[2] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
        newComponents[3] = oldComponents[1];
    } else {
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

    if (isGreyscale) {
        newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
        newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
        newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
        newComponents[3] = oldComponents[1];
    } else {
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

    if (isGreyscale) {
        sum = components[0];
    } else {
        sum = (components[0] + components[1] + components[2]) / 3.0;
    }

    return (sum >= 0.75);
}

@end
