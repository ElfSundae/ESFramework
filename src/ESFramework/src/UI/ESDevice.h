//
//  ESDevice.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESDevice : NSObject

/**
 * e.g. @"My iPhone"
 */
+ (NSString *)name;
/**
 * e.g. @"iOS"
 */
+ (NSString *)systemName;
/**
 * e.g. @"7.1"
 */
+ (NSString *)systemVersion;
/**
 * e.g. @"iPhone", @"iPod touch", @"iPhone Simulator"
 */
+ (NSString *)model;
/**
 * e.g. @"iPhone3,1", @"x86_64"
 * @see: http://theiphonewiki.com/wiki/Models
 */
+ (NSString *)platform;
/**
 * e.g. @"AT&T", @"ChinaNet"
 */
+ (NSString *)carrierString;

/**
 * Returns the device's UDID, a 40 hexadecimal numbers in lower-case,
 * using OpenUDID library.
 * If there's no OpenUDID class OR the
 * app runs in the Simulator, it will return
 * @"0000000000000000000000000000000000000000"
 *
 * @see https://github.com/ylechelle/OpenUDID
 */
+ (NSString *)deviceIdentifier;

+ (BOOL)isJailBroken;

+ (NSTimeZone *)localTimeZone;
+ (NSInteger)localTimeZoneFromGMT;

+ (NSLocale *)currentLocale;
/**
 * e.g. @"zh", @"en"
 */
+ (NSString *)currentLocaleLanguageCode;
/**
 * e.g. @"CN", @"US"
 */
+ (NSString *)currentLocaleCountryCode;
/**
 * languageCode_countryCode
 *
 * e.g. @"zh_CN", @"en_US"
 */
+ (NSString *)currentLocaleIdentifier;

@end
