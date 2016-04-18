//
//  NSDateFormatter+ESAppAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 16/04/04.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@implementation NSDateFormatter (_ESAppAdditions)

+ (NSDateFormatter *)appServerDateFormatterWithFullStyle
{
        static NSDateFormatter *__appServerDateFormatterWithFullStyle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appServerDateFormatterWithFullStyle = [[NSDateFormatter alloc] init];
                __appServerDateFormatterWithFullStyle.timeZone = [ESApp sharedApp].appWebServerTimeZone;
                __appServerDateFormatterWithFullStyle.dateFormat = @"yyyy'-'MM'-'dd HH':'mm':'ss";
        });
        return __appServerDateFormatterWithFullStyle;
}

+ (NSDateFormatter *)appServerDateFormatterWithFullDateStyle
{
        static NSDateFormatter *__appServerDateFormatterWithFullDateStyle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appServerDateFormatterWithFullDateStyle = [[NSDateFormatter alloc] init];
                __appServerDateFormatterWithFullDateStyle.timeZone = [ESApp sharedApp].appWebServerTimeZone;
                __appServerDateFormatterWithFullDateStyle.dateFormat = @"yyyy'-'MM'-'dd HH':'mm";
        });
        return __appServerDateFormatterWithFullDateStyle;
}

+ (NSDateFormatter *)appServerDateFormatterWithShortDateStyle
{
        static NSDateFormatter *__appServerDateFormatterWithShortDateStyle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appServerDateFormatterWithShortDateStyle = [[NSDateFormatter alloc] init];
                __appServerDateFormatterWithShortDateStyle.timeZone = [ESApp sharedApp].appWebServerTimeZone;
                __appServerDateFormatterWithShortDateStyle.dateFormat = @"MM'-'dd HH':'mm";
        });
        return __appServerDateFormatterWithShortDateStyle;
}

+ (NSDateFormatter *)appServerDateFormatterWithShortDateSecondsStyle
{
        static NSDateFormatter *__appServerDateFormatterWithShortDateSecondsStyle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appServerDateFormatterWithShortDateSecondsStyle = [[NSDateFormatter alloc] init];
                __appServerDateFormatterWithShortDateSecondsStyle.timeZone = [ESApp sharedApp].appWebServerTimeZone;
                __appServerDateFormatterWithShortDateSecondsStyle.dateFormat = @"MM'-'dd HH':'mm':'ss";
        });
        return __appServerDateFormatterWithShortDateSecondsStyle;
}

+ (NSDateFormatter *)appServerDateFormatterWithOnlyTimeStyle
{
        static NSDateFormatter *__appServerDateFormatterWithOnlyTimeStyle = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __appServerDateFormatterWithOnlyTimeStyle = [[NSDateFormatter alloc] init];
                __appServerDateFormatterWithOnlyTimeStyle.timeZone = [ESApp sharedApp].appWebServerTimeZone;
                __appServerDateFormatterWithOnlyTimeStyle.dateFormat = @"HH':'mm";
        });
        return __appServerDateFormatterWithOnlyTimeStyle;
}

@end
