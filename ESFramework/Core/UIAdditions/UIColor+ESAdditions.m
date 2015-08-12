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

- (NSString *)es_RGBString
{
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b alpha:NULL];
        return NSStringWith(@"rgb(%lu,%lu,%lu)", lroundf(r * 255.f), lroundf(g * 255.f), lroundf(b * 255.f));
}

- (NSString *)es_RGBAString
{
        CGFloat r, g, b, a;
        [self getRed:&r green:&g blue:&b alpha:&a];
        return NSStringWith(@"rgba(%lu,%lu,%lu,%g)", lroundf(r * 255.f), lroundf(g * 255.f), lroundf(b * 255.f), a);
}

- (NSString *)es_HexString
{
        CGFloat r, g, b;
        [self getRed:&r green:&g blue:&b alpha:NULL];
        return NSStringWith(@"#%02lX%02lX%02lX", lroundf(r * 255.f), lroundf(g * 255.f), lroundf(b * 255.f));
}

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

- (UIColor *)es_darkenColorWithValue:(CGFloat)value
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
                sum = (components[0] + components[1] + components[2]) / 3.0f;
        }
        
        return (sum >= 0.75f);
}

@end
