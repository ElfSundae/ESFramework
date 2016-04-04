//
//  NSDateFormatter+ESAppAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 16/04/04.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (ESAppAdditions)

/**
 * Shared NSDateFormatter instance with -[ESApp appWebServerTimeZone] timeZone.
 */

/// "yyyy'-'MM'-'dd HH':'mm':'ss"
+ (NSDateFormatter *)appServerDateFormatterWithFullStyle;
/// yyyy'-'MM'-'dd HH':'mm"
+ (NSDateFormatter *)appServerDateFormatterWithFullDateStyle;
/// "MM'-'dd HH':'mm"
+ (NSDateFormatter *)appServerDateFormatterWithShortDateStyle;
/// "MM'-'dd HH':'mm':'ss"
+ (NSDateFormatter *)appServerDateFormatterWithShortDateSecondsStyle;
/// "HH':'mm";
+ (NSDateFormatter *)appServerDateFormatterWithOnlyTimeStyle;

@end
