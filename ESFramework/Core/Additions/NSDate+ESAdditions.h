//
//  NSDate+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

//
// Date Format Patterns: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
//

#import <Foundation/Foundation.h>

@interface NSDate (ESAdditions)

/**
 * Timestamp
 */
+ (NSTimeInterval)timeIntervalSince1970;

- (BOOL)isBefore:(NSDate *)aDate;
- (BOOL)isAfter:(NSDate *)aDate;

/**
 * RFC1123 formatter.
 *
 * "EEE',' dd MMM yyyy HH':'mm':'ss z"
 */
+ (NSDateFormatter *)RFC1123DateFormatter;

/**
 * Convert RFC1123 Full Date string to NSDate.
 * http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
 *
 * This method allows three different formats:
 *      Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
 *      Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
 *      Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format
 */
+ (NSDate *)dateWithRFC1123String:(NSString *)string;

/**
 * Convert NSDate to RFC1123 Full Date string.
 * http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
 *
 * e.g. Sun, 06 Nov 1994 08:49:37 GMT
 */
- (NSString *)RFC1123String;

@end
