//
//  NSDateFormatter+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/17.
//  Copyright © 2019 https://0x123.com All rights reserved.
//

#import "NSDateFormatter+ESExtension.h"

@implementation NSDateFormatter (ESExtension)

+ (NSDateFormatter *)RFC1123DateFormatter
{
    static NSDateFormatter *_gRFC1123DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gRFC1123DateFormatter = [[NSDateFormatter alloc] init];
        _gRFC1123DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _gRFC1123DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        _gRFC1123DateFormatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    });
    return _gRFC1123DateFormatter;
}

+ (NSDateFormatter *)RFC1036DateFormatter
{
    static NSDateFormatter *_gRFC1036DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gRFC1036DateFormatter = [[NSDateFormatter alloc] init];
        _gRFC1036DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _gRFC1036DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        _gRFC1036DateFormatter.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
    });
    return _gRFC1036DateFormatter;
}

+ (NSDateFormatter *)ANSIDateFormatter
{
    static NSDateFormatter *_gANSIDateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gANSIDateFormatter = [[NSDateFormatter alloc] init];
        _gANSIDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        _gANSIDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        _gANSIDateFormatter.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    });
    return _gANSIDateFormatter;
}

@end
