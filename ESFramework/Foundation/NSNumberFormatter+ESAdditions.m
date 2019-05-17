//
//  NSNumberFormatter+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/24.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSNumberFormatter+ESAdditions.h"

@implementation NSNumberFormatter (ESAdditions)

+ (instancetype)defaultFormatter
{
    static NSNumberFormatter *_defaultFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultFormatter = [[self alloc] init];
        _defaultFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _defaultFormatter.usesGroupingSeparator = NO;
    });
    return _defaultFormatter;
}

@end
