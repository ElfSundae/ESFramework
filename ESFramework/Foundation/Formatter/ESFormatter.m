//
//  ESFormatter.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-16.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESFormatter.h"

@implementation ESFormatter

+ (NSString *)stringFromByteCount:(unsigned long long)fileSize
{
        NSString *result = @"";
        if (NSClassFromString(@"NSByteCountFormatter")) {
                result = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
        }
        return result;
}

@end
