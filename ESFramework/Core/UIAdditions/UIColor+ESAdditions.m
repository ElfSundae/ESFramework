//
//  UIColor+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIColor+ESAdditions.h"
#import "ESDefines.h"

ES_CATEGORY_FIX(UIColor_ESAdditions)

@implementation UIColor (ESAdditions)

- (NSString *)rgbaString
{
        CGFloat r, g, b, a;
        [self getRed:&r green:&g blue:&b alpha:&a];
        return [NSString stringWithFormat:@"rgb(%lu, %lu, %lu, %g)", (unsigned long)round(r * 0xFF), (unsigned long)round(g * 0xFF), (unsigned long)round(b * 0xFF), a];
}

- (NSString *)rgbString
{
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b alpha:NULL];
        return [NSString stringWithFormat:@"rgb(%lu, %lu, %lu)", (unsigned long)round(r * 0xFF), (unsigned long)round(g * 0xFF), (unsigned long)round(b * 0xFF)];
}

- (NSString *)hexString
{
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b alpha:NULL];
        return [NSString stringWithFormat:@"#%02lX%02lX%02lX", (unsigned long)round(r * 0xFF), (unsigned long)round(g * 0xFF), (unsigned long)round(b * 0xFF)];
}

+ (UIColor *)randomColor
{
        return [UIColor colorWithRed:(CGFloat)arc4random()/UINT_MAX green:(CGFloat)arc4random()/UINT_MAX blue:(CGFloat)arc4random()/UINT_MAX alpha:1.f];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

+ (UIColor *)es_groupTableViewBackgroundColor
{
        if (ESOSVersionIsAtLeast(NSFoundationVersionNumber_iOS_6_0)) {
                static UIImage *__esGroupTableViewBackgroundImage = nil;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                        UIGraphicsBeginImageContextWithOptions(CGSizeMake(7.f, 1.f), NO, 0.0);
                        CGContextRef c = UIGraphicsGetCurrentContext();
                        [[UIColor colorWithRed:185/255.f green:192/255.f blue:202/255.f alpha:1.f] setFill];
                        CGContextFillRect(c, CGRectMake(0, 0, 4, 1));
                        [[UIColor colorWithRed:185/255.f green:193/255.f blue:200/255.f alpha:1.f] setFill];
                        CGContextFillRect(c, CGRectMake(4, 0, 1, 1));
                        [[UIColor colorWithRed:192/255.f green:200/255.f blue:207/255.f alpha:1.f] setFill];
                        CGContextFillRect(c, CGRectMake(5, 0, 2, 1));
                        __esGroupTableViewBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                });
                return [UIColor colorWithPatternImage:__esGroupTableViewBackgroundImage];
        } else {
                return [UIColor groupTableViewBackgroundColor];
        }
}

+ (instancetype)alizarinColor {
        return [UIColor colorWithRed:0.906 green:0.298 blue:0.235 alpha:1.00];
}

+ (instancetype)amethystColor {
        return [UIColor colorWithRed:0.608 green:0.349 blue:0.714 alpha:1.00];
}

+ (instancetype)asbestosColor {
        return [UIColor colorWithRed:0.498 green:0.549 blue:0.553 alpha:1.00];
}

+ (instancetype)belizeHoleColor {
        return [UIColor colorWithRed:0.161 green:0.502 blue:0.725 alpha:1.00];
}

+ (instancetype)carrotColor {
        return [UIColor colorWithRed:0.902 green:0.494 blue:0.133 alpha:1.00];
}

+ (instancetype)cloudsColor {
        return [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1.00];
}

+ (instancetype)concreteColor {
        return [UIColor colorWithRed:0.584 green:0.647 blue:0.651 alpha:1.00];
}

+ (instancetype)emeraldColor {
        return [UIColor colorWithRed:0.180 green:0.800 blue:0.443 alpha:1.00];
}

+ (instancetype)greenSeaColor {
        return [UIColor colorWithRed:0.086 green:0.627 blue:0.522 alpha:1.00];
}

+ (instancetype)midnightBlueColor {
        return [UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1.00];
}

+ (instancetype)nephritisColor {
        return [UIColor colorWithRed:0.153 green:0.682 blue:0.376 alpha:1.00];
}

+ (instancetype)flatOrangeColor {
        return [UIColor colorWithRed:0.953 green:0.612 blue:0.071 alpha:1.00];
}

+ (instancetype)peterRiverColor {
        return [UIColor colorWithRed:0.204 green:0.596 blue:0.859 alpha:1.00];
}

+ (instancetype)pomegranateColor {
        return [UIColor colorWithRed:0.753 green:0.224 blue:0.169 alpha:1.00];
}

+ (instancetype)pumpkinColor {
        return [UIColor colorWithRed:0.827 green:0.329 blue:0.000 alpha:1.00];
}

+ (instancetype)silverColor {
        return [UIColor colorWithRed:0.741 green:0.765 blue:0.780 alpha:1.00];
}

+ (instancetype)sunFlowerColor {
        return [UIColor colorWithRed:0.945 green:0.769 blue:0.059 alpha:1.00];
}

+ (instancetype)turquoiseColor {
        return [UIColor colorWithRed:0.102 green:0.737 blue:0.612 alpha:1.00];
}

+ (instancetype)wetAsphaltColor {
        return [UIColor colorWithRed:0.204 green:0.286 blue:0.369 alpha:1.00];
}

+ (instancetype)wisteriaColor {
        return [UIColor colorWithRed:0.557 green:0.267 blue:0.678 alpha:1.00];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - BButton

- (BOOL)isLightColor
{
        NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
        BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
        
        CGFloat *components = (CGFloat *)CGColorGetComponents(self.CGColor);
        CGFloat sum;
        
        if(isGreyscale) {
                sum = components[0];
        }
        else {
                sum = (components[0] + components[1] + components[2]) / 3.0f;
        }
        
        return (sum >= 0.75f);
}

- (UIColor *)desaturatedColorToPercentSaturation:(CGFloat)percent
{
        CGFloat h, s, b, a;
        [self getHue:&h saturation:&s brightness:&b alpha:&a];
        return [UIColor colorWithHue:h saturation:s * percent brightness:b alpha:a];
}

- (UIColor *)lightenColorWithValue:(CGFloat)value
{
        NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
        BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
        
        CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
        CGFloat newComponents[4];
        
        if(isGreyscale) {
                newComponents[0] = oldComponents[0] + value > 1.0f ? 1.0f : oldComponents[0] + value;
                newComponents[1] = oldComponents[0] + value > 1.0f ? 1.0f : oldComponents[0] + value;
                newComponents[2] = oldComponents[0] + value > 1.0f ? 1.0f : oldComponents[0] + value;
                newComponents[3] = oldComponents[1];
        }
        else {
                newComponents[0] = oldComponents[0] + value > 1.0f ? 1.0f : oldComponents[0] + value;
                newComponents[1] = oldComponents[1] + value > 1.0f ? 1.0f : oldComponents[1] + value;
                newComponents[2] = oldComponents[2] + value > 1.0f ? 1.0f : oldComponents[2] + value;
                newComponents[3] = oldComponents[3];
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
        
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
        
        return retColor;
}

- (UIColor *)darkenColorWithValue:(CGFloat)value
{
        NSUInteger totalComponents = CGColorGetNumberOfComponents(self.CGColor);
        BOOL isGreyscale = (totalComponents == 2) ? YES : NO;
        
        CGFloat *oldComponents = (CGFloat *)CGColorGetComponents(self.CGColor);
        CGFloat newComponents[4];
        
        if(isGreyscale) {
                newComponents[0] = oldComponents[0] - value < 0.0f ? 0.0f : oldComponents[0] - value;
                newComponents[1] = oldComponents[0] - value < 0.0f ? 0.0f : oldComponents[0] - value;
                newComponents[2] = oldComponents[0] - value < 0.0f ? 0.0f : oldComponents[0] - value;
                newComponents[3] = oldComponents[1];
        }
        else {
                newComponents[0] = oldComponents[0] - value < 0.0f ? 0.0f : oldComponents[0] - value;
                newComponents[1] = oldComponents[1] - value < 0.0f ? 0.0f : oldComponents[1] - value;
                newComponents[2] = oldComponents[2] - value < 0.0f ? 0.0f : oldComponents[2] - value;
                newComponents[3] = oldComponents[3];
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
        
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
        
        return retColor;
}
@end
