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
#import <sys/sysctl.h>
#import <mach/mach.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "ESHelpers.h"
#import "ESValue.h"

@implementation UIDevice (ESInfo)

+ (void)load
{
    ESSwizzleInstanceMethod(self, @selector(systemName), @selector(es_systemName));
}

- (NSString *)es_systemName
{
    NSString *name = [self es_systemName];
    if ([name isEqualToString:@"iPhone OS"]) {
        name = @"iOS";
    }
    return name;
}

- (NSString *)platform
{
    static NSString *_platform = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = (char *)malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        _platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
    });
    return _platform;
}

- (nullable NSArray<NSString *> *)carrierNames
{
    NSArray *carrierNames = nil;
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    if (@available(iOS 13.0, *)) {
        carrierNames = [networkInfo.serviceSubscriberCellularProviders.allValues valueForKeyPath:@"@unionOfObjects.carrierName"];
    } else {
        NSString *name = networkInfo.subscriberCellularProvider.carrierName;
        if (name) {
            carrierNames = @[ name ];
        }
    }
    return carrierNames.count ? carrierNames : nil;
}

- (nullable NSString *)carrierName
{
    return self.carrierNames.firstObject;
}

- (nullable NSString *)WiFiSSID
{
    NSString *ssid = nil;
    NSArray *interfaces = CFBridgingRelease(CNCopySupportedInterfaces());
    for (NSString *name in interfaces) {
        CFStringRef interface = (__bridge CFStringRef)name; // @"en0"
        NSDictionary *info = CFBridgingRelease(CNCopyCurrentNetworkInfo(interface));
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];
            break;
        }
    }
    return ssid;
}

- (BOOL)isJailbroken
{
    static BOOL _isJailbroken = NO;
#if !TARGET_IPHONE_SIMULATOR
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *jbApps = @[
            @"/Application/Cydia.app",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/bin/bash",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/private/var/lib/cydia",
            @"/private/var/lib/apt",
        ];
        for (NSString *path in jbApps) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                _isJailbroken = YES;
                break;
            }
        }

        if (!_isJailbroken && 0 == popen("ls", "r")) {
            _isJailbroken = YES;
        }
    });
#endif
    return _isJailbroken;
}

+ (unsigned long long)diskFreeSize
{
    return ESULongLongValue([[NSFileManager defaultManager] attributesOfFileSystemForPath:ESPathForDocuments() error:NULL][NSFileSystemFreeSize]);
}

+ (NSString *)diskFreeSizeString
{
    return [NSByteCountFormatter stringFromByteCount:(long long)[self diskFreeSize] countStyle:NSByteCountFormatterCountStyleFile];
}

+ (unsigned long long)diskTotalSize
{
    return ESULongLongValue([[NSFileManager defaultManager] attributesOfFileSystemForPath:ESPathForDocuments() error:NULL][NSFileSystemSize]);
}

+ (NSString *)diskTotalSizeString
{
    return [NSByteCountFormatter stringFromByteCount:(long long)[self diskTotalSize] countStyle:NSByteCountFormatterCountStyleFile];
}

+ (CGSize)screenSizeInPoints
{
    return [UIScreen mainScreen].bounds.size;
}

+ (CGSize)screenSizeInPixels
{
    return [[UIScreen mainScreen] currentMode].size;
}

+ (NSString *)screenSizeString:(CGSize)size
{
    return [NSString stringWithFormat:@"%dx%d",
            (int)fmin(size.width, size.height),
            (int)fmax(size.width, size.height)];
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

+ (NSDictionary *)getNetworkInterfacesIncludesLoopback:(BOOL)includesLoopback
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    struct ifaddrs *interfaces = NULL;
    const struct ifaddrs *cursor = NULL;
    if ((getifaddrs(&interfaces) == 0)) {
        for (cursor = interfaces; cursor != NULL; cursor = cursor->ifa_next) {
            if (!(cursor->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */) {
                continue;                 // deeply nested code harder to read
            }
            if (!includesLoopback && strcmp(cursor->ifa_name, "lo0") == 0) {
                continue;                 // skip Loopback address
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
    return [result copy];
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
