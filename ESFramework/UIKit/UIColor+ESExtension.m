//
//  UIColor+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/16.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import "UIColor+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

@implementation UIColor (ESExtension)

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

@end

#endif
