//
//  UIDevice+ESInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDefines.h"

/**
 * Formats a number of bytes in a human-readable format. e.g. @"12.34 bytes", @"123 GB"
 *
 * Returns a string showing the size in bytes, KBs, MBs, or GBs. Steps with 1024 bytes.
 */
ES_EXTERN NSString *NSStringFromFileSizeBytes(unsigned long long fileSize);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@interface UIDevice (ESInfo)

///=============================================
/// @name Basic information
///=============================================

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
 * e.g. @"11D169"
 */
+ (NSString *)systemBuildIdentifier;
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
 * Returns the current Wi-Fi SSID.
 */
+ (NSString *)currentWiFiSSID;

/**
 * Returns the device's UDID, a 40 hexadecimal numbers in lower-case, using **OpenUDID** library.
 * e.g. @"36acf6e5d9f3bf66d2084dbc2b2b07f895ea9848"
 *
 * iOS Simulator will always returns @"0000000000000000000000000000000000000000"
 *
 * @see [OpenUDID](https://github.com/ylechelle/OpenUDID)
 */
+ (NSString *)deviceIdentifier;

/**
 * Detect whether this device has been jailbroken.
 */
+ (BOOL)isJailBroken;

/**
 * Returns `ESIsPhoneDevice()`
 */
+ (BOOL)isPhoneDevice;
/**
 * Returns `ESIsPadDevice()`
 */
+ (BOOL)isPadDevice;

///=============================================
/// @name Disk space
///=============================================

+ (unsigned long long)diskFreeSize;
+ (NSString *)diskFreeSizeString;
+ (unsigned long long)diskTotalSize;
+ (NSString *)diskTotalSizeString;

///=============================================
/// @name Screen
///=============================================
/**
 * The width and height in pixels.
 * e.g. 640x960
 */
+ (CGSize)screenSize;
/**
 * e.g. @"640x960", the `width` is always littler than `height`.
 */
+ (NSString *)screenSizeString;

+ (BOOL)isRetinaScreen;
+ (BOOL)isIPhoneRetina4InchScreen;
+ (BOOL)isIPhoneRetina35InchScreen;

///=============================================
/// @name Locale
///=============================================

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
