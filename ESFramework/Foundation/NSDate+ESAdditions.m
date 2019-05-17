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

- (BOOL)isBefore:(NSDate *)aDate
{
    return [self compare:aDate] == NSOrderedAscending;
}

- (BOOL)isAfter:(NSDate *)aDate
{
    return [self compare:aDate] == NSOrderedDescending;
}

- (BOOL)isToday
{
    return [NSCalendar.currentCalendar isDateInToday:self];
}

- (BOOL)isYesterday
{
    return [NSCalendar.currentCalendar isDateInYesterday:self];
}

- (BOOL)isTomorrow
{
    return [NSCalendar.currentCalendar isDateInTomorrow:self];
}

- (BOOL)isWeekend
{
    return [NSCalendar.currentCalendar isDateInWeekend:self];
}

- (BOOL)isWorkday
{
    return !self.isWeekend;
}

- (BOOL)isInThisWeek
{
    return [NSCalendar.currentCalendar isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitWeekday];
}

- (NSString *)RFC1123String
{
    return [[NSDateFormatter RFC1123DateFormatter] stringFromDate:self];
}

+ (NSDate *)dateFromRFC1123String:(NSString *)string
{
    return [[NSDateFormatter RFC1123DateFormatter] dateFromString:string];
}

- (NSString *)HTTPDateString
{
    return [self RFC1123String];
}

+ (NSDate *)dateFromHTTPDateString:(NSString *)string
{
    NSUInteger commaPosition = [string rangeOfString:@","].location;

    if (commaPosition == 3) {
        return [self dateFromRFC1123String:string];
    } else if (commaPosition != NSNotFound && commaPosition > 3) {
        return [[NSDateFormatter RFC1036DateFormatter] dateFromString:string];
    } else if (commaPosition == NSNotFound) {
        return [[NSDateFormatter ANSIDateFormatter] dateFromString:string];
    }

    return nil;
}

@end
