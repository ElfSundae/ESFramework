//
//  NSDate+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/08.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

//
// Date Format Patterns: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ESExtension)

- (BOOL)isBefore:(NSDate *)aDate;
- (BOOL)isAfter:(NSDate *)aDate;

- (BOOL)isInFuture;
- (BOOL)isInPast;
- (BOOL)isInWeekend;
- (BOOL)isInWorkday;

- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;
- (BOOL)isThisWeek;
- (BOOL)isThisMonth;
- (BOOL)isThisYear;

/**
 * Converts HTTP-date string to NSDate.
 * http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
 *
 * This method allows three different formats:
 *      Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
 *      Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
 *      Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format
 */
+ (nullable NSDate *)dateWithHTTPDateString:(NSString *)string;

/**
 * Converts date to HTTP-date string, this method is an alias to -RFC1123String .
 */
- (NSString *)HTTPDateString;

@end

NS_ASSUME_NONNULL_END
