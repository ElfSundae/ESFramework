//
//  NSDateFormatter+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/17.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDateFormatter (ESExtension)

/**
 * Returns the RFC 1123 full date formatter.
 *
 * "EEE',' dd MMM yyyy HH':'mm':'ss z"
 * Sun, 06 Nov 1994 08:49:37 GMT
 *
 * HTTP-date: [RFC 7231, section 7.1.1.2: Date](https://tools.ietf.org/html/rfc7231#section-7.1.1.2)
 */
+ (NSDateFormatter *)RFC1123DateFormatter;

/**
 * Returns the RFC 1036 (RFC 850) date formatter.
 *
 * "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z"
 * Sunday, 06-Nov-94 08:49:37 GMT
 */
+ (NSDateFormatter *)RFC1036DateFormatter;

/**
 * Returns the ANSI C's asctime() date format.
 *
 * "EEE MMM d HH':'mm':'ss yyyy"
 * Sun Nov 6 08:49:37 1994
 */
+ (NSDateFormatter *)ANSIDateFormatter;

@end

NS_ASSUME_NONNULL_END
