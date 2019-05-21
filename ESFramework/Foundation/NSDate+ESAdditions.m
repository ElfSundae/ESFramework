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

- (BOOL)isInFuture
{
    return [self isAfter:[NSDate date]];
}

- (BOOL)isInPast
{
    return [self isBefore:[NSDate date]];
}

- (BOOL)isWeekend
{
    return [NSCalendar.currentCalendar isDateInWeekend:self];
}

- (BOOL)isWorkday
{
    return !self.isWeekend;
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

- (BOOL)isThisWeek
{
    return [NSCalendar.currentCalendar isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitWeekday];
}

- (BOOL)isThisMonth
{
    return [NSCalendar.currentCalendar isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitMonth];
}

- (BOOL)isThisYear
{
    return [NSCalendar.currentCalendar isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear];
}

+ (NSDate *)dateFromHTTPDateString:(NSString *)string
{
    NSUInteger commaPosition = [string rangeOfString:@","].location;

    if (commaPosition == 3) {
        return [[NSDateFormatter RFC1123DateFormatter] dateFromString:string];
    } else if (commaPosition != NSNotFound && commaPosition > 3) {
        return [[NSDateFormatter RFC1036DateFormatter] dateFromString:string];
    } else if (commaPosition == NSNotFound) {
        return [[NSDateFormatter ANSIDateFormatter] dateFromString:string];
    }

    return nil;
}

- (NSString *)HTTPDateString
{
    return [[NSDateFormatter RFC1123DateFormatter] stringFromDate:self];
}

@end
