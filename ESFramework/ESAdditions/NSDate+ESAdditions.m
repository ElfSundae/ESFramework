//
//  NSDate+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDate+ESAdditions.h"
#import "ESDefines.h"

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

+ (NSDateFormatter *)RFC1123DateFormatter
{
        static NSDateFormatter *__rfc1123DateFormatter = nil;
        static dispatch_once_t onceTokenRFC1123DateFormatter;
        dispatch_once(&onceTokenRFC1123DateFormatter, ^{
                __rfc1123DateFormatter = [[NSDateFormatter alloc] init];
                __rfc1123DateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                __rfc1123DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
                __rfc1123DateFormatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
        });
        return __rfc1123DateFormatter;
}

+ (NSDate *)dateWithRFC1123String:(NSString *)string
{
        if (!ESIsStringWithAnyText(string)) {
                return nil;
        }
        
        NSUInteger commaPosition = [string rangeOfString:@","].location;
        
        if (commaPosition == 3) {
                return [[self RFC1123DateFormatter] dateFromString:string];
        }
        
        if (commaPosition > 3 && commaPosition != NSNotFound) {
                static NSDateFormatter *rfc1036Formatter = nil;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                        rfc1036Formatter = [[NSDateFormatter alloc] init];
                        rfc1036Formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                        rfc1036Formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
                        rfc1036Formatter.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
                });
                return [rfc1036Formatter dateFromString:string];
        }
        
        if (commaPosition == NSNotFound) {
                static NSDateFormatter *asctimeFormatter = nil;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                        asctimeFormatter = [[NSDateFormatter alloc] init];
                        asctimeFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
                        asctimeFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
                        asctimeFormatter.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
                });
                return [asctimeFormatter dateFromString:string];
        }
        
        return nil;
}

- (NSString *)RFC1123String
{
        return [[[self class] RFC1123DateFormatter] stringFromDate:self];
}

@end
