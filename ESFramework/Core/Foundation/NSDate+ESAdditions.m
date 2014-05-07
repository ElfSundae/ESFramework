//
//  NSDate+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDate+ESAdditions.h"

@implementation NSDate (ESAdditions)

+ (NSTimeInterval)nowTimeInterval
{
        return [[self date] timeIntervalSince1970];
}

+ (unsigned long long)timestamp
{
        return (unsigned long long)[self nowTimeInterval];
}

@end
