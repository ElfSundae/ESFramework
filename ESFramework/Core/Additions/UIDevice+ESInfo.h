//
//  UIDevice+ESInfo.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESDefines.h"

#define kESNetworkInterfaceFamilyIPv4           @"IPv4"
#define kESNetworkInterfaceFamilyIPv6           @"IPv6"
#define kESNetworkInterfaceNameLoopback         @"lo0" // localhost
#define kESNetworkInterfaceNameCellular         @"pdp_ip0"
#define kESNetworkInterfaceNameWiFi             @"en0"
#define kESNetworkInterfaceNameVPN              @"utun0"
#define kESNetworkInterfaceNameAWDL             @"awdl0" // AWDL (Apple Wireless Direct Link)


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
 * e.g. @"iPhone OS" @"iOS"
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
 * Returns the subscriber's cellular service provider.
 * e.g. @"AT&T", @"ChinaNet"
 */
+ (NSString *)carrierString;
/**
 * Returns the current Wi-Fi SSID
 */
+ (NSString *)currentWiFiSSID;

/**
 * Detect whether this device has been jailbroken.
 */
+ (BOOL)isJailbroken;

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
 */
+ (CGSize)screenSizeInPixels;

/**
 * The width and height in points
 */
+ (CGSize)screenSizeInPoints;

+ (BOOL)isRetinaScreen;
// iPhone 4/4S, 640x960
+ (BOOL)isIPhoneRetina35InchScreen;
// iPhone 5/5S, 640x1136
+ (BOOL)isIPhoneRetina4InchScreen;
// iPhone 6, 750x1334
+ (BOOL)isIPhoneRetina47InchScreen;
// iPhone 6 Plus, 1242x2208
+ (BOOL)isIPhoneRetina55InchScreen;

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

///=============================================
/// @name Network Interfaces
///=============================================

/**
 * Returns network interfaces names and addresses.
 *
 * e.g.
 * @code
 * {
 *     IPv4 = {
 *         en0 = "192.168.2.115";
 *         lo0 = "127.0.0.1";
 *         "pdp_ip0" = "100.114.247.226";
 *     };
 *     IPv6 = {
 *         awdl0 = "fe80::5c75:e1ff:fe4e:f45a";
 *         en0 = "fe80::881:8a52:89cb:bb89";
 *         lo0 = "fe80::1";
 *     };
 * }
 * @endcode
 */
+ (NSDictionary *)getNetworkInterfacesIncludesLoopback:(BOOL)includesLoopback;

/**
 * Returns IPv4 address on en0.
 */
+ (NSString *)localIPv4Address;

/**
 * Returns IPv6 address on en0.
 */
+ (NSString *)localIPv6Address;

@end
