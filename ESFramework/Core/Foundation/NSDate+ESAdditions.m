//
//  NSDate+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDate+ESAdditions.h"
#import "ESDefines.h"

ES_CATEGORY_FIX(NSDate_ESAdditions)

@implementation NSDate (ESAdditions)

+ (NSTimeInterval)timeIntervalSince1970
{
        return [[self date] timeIntervalSince1970];
}

+ (unsigned long long)timestamp
{
        return (unsigned long long)[self timeIntervalSince1970];
}

- (BOOL)isBefore:(NSDate *)aDate
{
        return [self timeIntervalSinceDate:aDate] < 0;
}

- (BOOL)isAfter:(NSDate *)aDate
{
        return [self timeIntervalSinceDate:aDate] > 0;
}

@end
