//
//  NSDateFormatter+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/17.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSDateFormatter+ESAdditions.h"

@implementation NSDateFormatter (ESAdditions)

+ (NSDateFormatter *)RFC1123DateFormatter
{
    static NSDateFormatter *_gRFC1123DateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gRFC1123DateFormatter = [[NSDateFormatter alloc] init];
        _gRFC1123DateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        _gRFC1123DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
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
        _gRFC1036DateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        _gRFC1036DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
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
        _gANSIDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        _gANSIDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        _gANSIDateFormatter.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
    });
    return _gANSIDateFormatter;
}

@end
