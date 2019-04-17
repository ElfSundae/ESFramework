//
//  NSDate+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDate+ESAdditions.h"
#import "NSDateFormatter+ESAdditions.h"

@implementation NSDate (ESAdditions)

+ (NSTimeInterval)timeIntervalSince1970
{
    return [[self date] timeIntervalSince1970];
}

- (BOOL)isBefore:(NSDate *)aDate
{
    return [self timeIntervalSinceDate:aDate] < 0;
}

- (BOOL)isAfter:(NSDate *)aDate
{
    return [self timeIntervalSinceDate:aDate] > 0;
}

+ (NSDate *)dateFromRFC1123String:(NSString *)string
{
    return [[NSDateFormatter RFC1123DateFormatter] dateFromString:string];
}

+ (NSDate *)dateFromHTTPDateString:(NSString *)string
{
    NSUInteger commaPosition = [string rangeOfString:@","].location;

    if (commaPosition == 3) {
        return [self dateFromRFC1123String:string];
    }

    if (commaPosition != NSNotFound && commaPosition > 3) {
        return [[NSDateFormatter RFC1036DateFormatter] dateFromString:string];
    }

    if (commaPosition == NSNotFound) {
        return [[NSDateFormatter ANSIDateFormatter] dateFromString:string];
    }

    return nil;
}

- (NSString *)RFC1123String
{
    return [[NSDateFormatter RFC1123DateFormatter] stringFromDate:self];
}

@end
