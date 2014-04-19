//
//  NSDate+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ESAdditions)

+ (NSTimeInterval)nowTimeInterval;
- (NSTimeInterval)microseconds;

/// Default is @"yyyy-MM-dd HH:mm:ss"
+ (NSString *)defaultDateFormat;
+ (void)setDefaultDateFormat:(NSString *)dateFormat;
/// Default is [NSTimeZone defaultTimeZone]
+ (NSTimeZone *)defaultTimeZone;
+ (void)setDefaultTimeZone:(NSTimeZone *)timeZone;

+ (NSDateFormatter *)sharedDateFormatter;
+ (NSDateFormatter *)sharedDateFormatterWithDateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;

+ (NSDate *)dateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
