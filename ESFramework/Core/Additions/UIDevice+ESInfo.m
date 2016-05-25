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
#import "ESDefines.h"
#import "ESValue.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
        for (NSString *name in interfaces) {
                CFStringRef interface = (__bridge CFStringRef)name; // @"en0"
                NSDictionary *info = CFBridgingRelease(CNCopyCurrentNetworkInfo(interface));
#pragma clang diagnostic pop
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
                                    @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                    @"/bin/bash",
                                    @"/usr/sbin/sshd",
                                    @"/etc/apt",
                                    @"/private/var/lib/cydia",
                                    @"/private/var/lib/apt",
                                    ];
                for (NSString *path in jbApps) {
                        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                __isJailBroken = YES;
                                break;
                        }
                }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                if (!__isJailBroken && 0 == system("ls")) {
                        __isJailBroken = YES;
                }
#pragma clang diagnostic pop
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

+ (CGSize)screenSizeInPixels
{
        return [[UIScreen mainScreen] currentMode].size;
}

+ (CGSize)screenSizeInPoints
{
        return [UIScreen mainScreen].bounds.size;
}

+ (BOOL)isRetinaScreen
{
        return UIScreenIsRetina();
}

+ (BOOL)isIPhoneRetina35InchScreen
{
        return CGSizeEqualToSize([self screenSizeInPixels], CGSizeMake(640., 960.));
}

+ (BOOL)isIPhoneRetina4InchScreen
{
        return CGSizeEqualToSize([self screenSizeInPixels], CGSizeMake(640., 1136.));
}

+ (BOOL)isIPhoneRetina47InchScreen
{
        return CGSizeEqualToSize([self screenSizeInPixels], CGSizeMake(750., 1334.));
}

+ (BOOL)isIPhoneRetina55InchScreen
{
        return CGSizeEqualToSize([self screenSizeInPixels], CGSizeMake(1242., 2208.));
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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Network Interfaces

+ (NSDictionary *)getNetworkInterfacesIncludesLoopback:(BOOL)includesLoopback
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        struct ifaddrs *interfaces = NULL;
        const struct ifaddrs *cursor = NULL;
        if ((getifaddrs(&interfaces) == 0)) {
                for (cursor = interfaces; cursor != NULL; cursor = cursor->ifa_next) {
                        if (!(cursor->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                                continue; // deeply nested code harder to read
                        }
                        if (!includesLoopback && strcmp(cursor->ifa_name, "lo0") == 0) {
                                continue; // skip Loopback address
                        }
                        
                        NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                        NSString *family = nil;
                        NSString *ip = nil;
                        if (cursor->ifa_addr->sa_family == AF_INET) {
                                char ipBuffer[INET_ADDRSTRLEN];
                                struct sockaddr_in *addr = (struct sockaddr_in *)cursor->ifa_addr;
                                if (inet_ntop(AF_INET, &addr->sin_addr, ipBuffer, sizeof(ipBuffer))) {
                                        family = kESNetworkInterfaceFamilyIPv4;
                                        ip = [NSString stringWithUTF8String:ipBuffer];
                                }
                        } else if (cursor->ifa_addr->sa_family == AF_INET6) {
                                char ipBuffer[INET6_ADDRSTRLEN];
                                struct sockaddr_in6 *addr = (struct sockaddr_in6 *)cursor->ifa_addr;
                                if (inet_ntop(AF_INET6, &addr->sin6_addr, ipBuffer, sizeof(ipBuffer))) {
                                        family = kESNetworkInterfaceFamilyIPv6;
                                        ip = [NSString stringWithUTF8String:ipBuffer];
                                }
                        }
                        
                        if (name && family && ip) {
                                if (!result[family]) {
                                        result[family] = [NSMutableDictionary dictionary];
                                }
                                result[family][name] = ip;
                        }
                }
                
                freeifaddrs(interfaces);
        }
        return result;
}

+ (NSString *)localIPv4Address
{
        return [self getNetworkInterfacesIncludesLoopback:NO][kESNetworkInterfaceFamilyIPv4][kESNetworkInterfaceNameWiFi];
}

+ (NSString *)localIPv6Address
{
        return [self getNetworkInterfacesIncludesLoopback:NO][kESNetworkInterfaceFamilyIPv6][kESNetworkInterfaceNameWiFi];
}

@end
