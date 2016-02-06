//
//  UIDevice+ESInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIDevice+ESInfo.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <ESFramework/ESDefines.h>
#import <ESFramework/ESValue.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIDevice (ESInfo)

@implementation UIDevice (ESInfo)

+ (NSString *)name
{
        return ([[UIDevice currentDevice] name] ?: @"");
}
+ (NSString *)systemName
{
        return [[UIDevice currentDevice] systemName];
}
+ (NSString *)systemVersion
{
        return [[UIDevice currentDevice] systemVersion];
}
+ (NSString *)systemBuildIdentifier
{
        static NSString *__gBuildIdentifier = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                NSString *build = nil;
                int mib[] = { CTL_KERN, KERN_OSVERSION };
                size_t size;
                sysctl(mib, 2, NULL, &size, NULL, 0);
                char *str = malloc(size);
                if (sysctl(mib, 2, str, &size, NULL, 0) >= 0) {
                        build = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
                }
                free(str);
                __gBuildIdentifier = build ?: @"";
        });
        return __gBuildIdentifier;
}
+ (NSString *)model
{
        return [[UIDevice currentDevice] model];
}

+ (NSString *)platform
{
        static NSString *__gPlatfrom = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                size_t size;
                sysctlbyname("hw.machine", NULL, &size, NULL, 0);
                char *machine = malloc(size);
                sysctlbyname("hw.machine", machine, &size, NULL, 0);
                NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
                free(machine);
                __gPlatfrom = platform ?: @"";
        });
        return __gPlatfrom;
}

+ (NSString *)carrierString
{
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier_t = [netInfo subscriberCellularProvider];
        NSString *carrier = [carrier_t carrierName];
        return carrier ?: @"";
}

+ (NSString *)currentWiFiSSID
{
        NSString *ssid = nil;
#if !TARGET_IPHONE_SIMULATOR
        NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
        for (NSString *name in interfaces) {
                CFStringRef interface = (__bridge CFStringRef)name; // @"en0"
                NSDictionary *info = CFBridgingRelease(CNCopyCurrentNetworkInfo(interface));
                if (info[@"SSID"]) {
                        ssid = info[@"SSID"];
                        break;
                }
        }
#endif
        return ssid ?: @"";
}

+ (BOOL)isJailbroken
{
        static BOOL __isJailBroken = NO;
#if !TARGET_IPHONE_SIMULATOR
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                NSArray *jbApps = @[@"/Application/Cydia.app",
                                    @"/private/var/lib/cydia",
                                    @"/private/var/lib/apt",
                                    ];
                for (NSString *path in jbApps) {
                        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                __isJailBroken = YES;
                                break;
                        }
                }
                if (!__isJailBroken && 0 == system("ls")) {
                        __isJailBroken = YES;
                }
        });
#endif
        return __isJailBroken;
}

+ (BOOL)isPhoneDevice
{
        return ESIsPhoneDevice();
}

+ (BOOL)isPadDevice
{
        return ESIsPadDevice();
}

+ (unsigned long long)diskFreeSize
{
        return ESULongLongValue([[NSFileManager defaultManager] attributesOfFileSystemForPath:ESPathForDocuments() error:NULL][NSFileSystemFreeSize]);
}

+ (NSString *)diskFreeSizeString
{
        return [NSByteCountFormatter stringFromByteCount:(long long)[self diskFreeSizeString] countStyle:NSByteCountFormatterCountStyleFile];
}

+ (unsigned long long)diskTotalSize
{
        return ESULongLongValue([[NSFileManager defaultManager] attributesOfFileSystemForPath:ESPathForDocuments() error:NULL][NSFileSystemSize]);
}

+ (NSString *)diskTotalSizeString
{
        return [NSByteCountFormatter stringFromByteCount:(long long)[self diskTotalSize] countStyle:NSByteCountFormatterCountStyleFile];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Screen

+ (CGSize)screenSize
{
        return [[UIScreen mainScreen] currentMode].size;
}

+ (NSString *)screenSizeString
{
        CGSize size = [self screenSize];
        if (size.width > size.height) {
                CGFloat t = size.width;
                size.width = size.height;
                size.height = t;
        }
        return [NSString stringWithFormat:@"%dx%d", (int)size.width, (int)size.height];
}

+ (BOOL)isRetinaScreen
{
        return UIScreenIsRetina();
}

+ (BOOL)isIPhoneRetina35InchScreen
{
        return CGSizeEqualToSize([self screenSize], CGSizeMake(640.f, 960.f));
}

+ (BOOL)isIPhoneRetina4InchScreen
{
        return CGSizeEqualToSize([self screenSize], CGSizeMake(640.f, 1136.f));
}

+ (BOOL)isIPhoneRetina47InchScreen
{
        return CGSizeEqualToSize([self screenSize], CGSizeMake(750.f, 1334.f));
}

+ (BOOL)isIPhoneRetina55InchScreen
{
        return CGSizeEqualToSize([self screenSize], CGSizeMake(1242.f, 2208.f));
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Locale

+ (NSTimeZone *)localTimeZone
{
        return [NSTimeZone localTimeZone];
}

+ (NSInteger)localTimeZoneFromGMT
{
        return ([[NSTimeZone localTimeZone] secondsFromGMT] / 3600);
}

+ (NSLocale *)currentLocale
{
        return [NSLocale currentLocale];
}

+ (NSString *)currentLocaleLanguageCode
{
        return [[self currentLocale] objectForKey:NSLocaleLanguageCode];
}

+ (NSString *)currentLocaleCountryCode
{
        return [[self currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString *)currentLocaleIdentifier
{
        return [[self currentLocale] localeIdentifier];
}

@end
