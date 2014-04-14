//
//  UIDevice+ESInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ESInfo)
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
 * Returns the device's UDID, a 40 hexadecimal numbers in lower-case, using OpenUDID library.
 * e.g. @"36acf6e5d9f3bf66d2084dbc2b2b07f895ea9848"
 *
 * iOS Simulator will always returns @"0000000000000000000000000000000000000000"
 *
 * @see https://github.com/ylechelle/OpenUDID
 */
+ (NSString *)deviceIdentifier;

+ (BOOL)isJailBroken;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Screen
/**
 * The width and height in pixels.
 * e.g. 640x960
 */
+ (CGSize)screenSize;
+ (NSString *)screenSizeString;
+ (BOOL)isRetinaScreen;
+ (BOOL)isIPhoneRetina4InchScreen;
+ (BOOL)isIPhoneRetina35InchScreen;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Locale

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
 * languageCode_countryCode.
 * e.g. @"zh_CN", @"en_US"
 */
+ (NSString *)currentLocaleIdentifier;

@end
