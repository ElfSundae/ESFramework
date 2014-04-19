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

- (NSTimeInterval)microseconds
{
        return ([self timeIntervalSince1970] * 1000000.0);
}

static NSString *__defaultDateFormat = @"yyyy-MM-dd HH:mm:ss";
+ (NSString *)defaultDateFormat
{
        return __defaultDateFormat;
}
+ (void)setDefaultDateFormat:(NSString *)dateFormat
{
        if (dateFormat) {
                __defaultDateFormat = dateFormat;
        }
}

static NSTimeZone *__defaultTimeZone = nil;
+ (NSTimeZone *)defaultTimeZone
{
        if (nil == __defaultTimeZone) {
                __defaultTimeZone = [NSTimeZone defaultTimeZone];
        }
        return __defaultTimeZone;
}

+ (void)setDefaultTimeZone:(NSTimeZone *)timeZone
{
        if (timeZone) {
                __defaultTimeZone = timeZone;
        }
}

+ (NSDateFormatter *)sharedDateFormatter
{
        return [self sharedDateFormatterWithDateFormat:nil timeZone:nil];
}

+ (NSDateFormatter *)sharedDateFormatterWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone
{
        static NSDateFormatter *_dateFormatter = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                _dateFormatter = [[NSDateFormatter alloc] init];
        });
        
        _dateFormatter.dateFormat = ([dateFormat isKindOfClass:[NSString class]] ? dateFormat : [self defaultDateFormat]);
        _dateFormatter.timeZone = ([timeZone isKindOfClass:[NSTimeZone class]] ? timeZone : [self defaultTimeZone]);
        
        return _dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone
{
        return [[self sharedDateFormatterWithDateFormat:dateFormat timeZone:timeZone] dateFromString:dateString];
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
        return [self dateFromString:dateString dateFormat:nil timeZone:nil];
}

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone
{
        return [[self sharedDateFormatterWithDateFormat:dateFormat timeZone:timeZone] stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
        return [self stringFromDate:date dateFormat:nil timeZone:nil];
}

@end
