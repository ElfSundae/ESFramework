//
//  NSDate+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "NSDate+ESAdditions.h"

@implementation NSDate (ESAdditions)

+ (NSTimeInterval)nowTimeInterval
{
        return [[self date] timeIntervalSince1970];
}

- (NSTimeInterval)microseconds
{
        return ([self timeIntervalSince1970] * 1000000.0);
}

@end
