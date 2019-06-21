//
//  NSDate+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/08.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import "NSDate+ESExtension.h"
#import "NSDateFormatter+ESExtension.h"

@implementation NSDate (ESExtension)

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

- (BOOL)isInWeekend
{
    return [NSCalendar.currentCalendar isDateInWeekend:self];
}

- (BOOL)isInWorkday
{
    return !self.isInWeekend;
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
    return [NSCalendar.currentCalendar isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitWeekOfYear];
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
