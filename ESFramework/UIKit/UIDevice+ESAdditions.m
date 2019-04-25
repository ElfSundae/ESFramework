//
//  UIDevice+ESInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIDevice+ESAdditions.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "ESHelpers.h"
#import "ESValue.h"

@implementation UIDevice (ESAdditions)

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
    if (@available(iOS 12.0, *)) {
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

- (nullable NSDictionary *)WiFiNetworkInfo
{
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces) {
        CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo((CFStringRef)CFArrayGetValueAtIndex(interfaces, 0));
        CFRelease(interfaces);
        return CFBridgingRelease(networkInfo);
    }
    return nil;
}

- (nullable NSString *)WiFiSSID
{
    return self.WiFiNetworkInfo[(__bridge NSString *)kCNNetworkInfoKeySSID];
}

- (nullable NSString *)WiFiBSSID
{
    return self.WiFiNetworkInfo[(__bridge NSString *)kCNNetworkInfoKeyBSSID];
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

- (nullable id)es_attributeOfFileSystem:(NSFileAttributeKey)key
{
    return [NSFileManager.defaultManager attributesOfFileSystemForPath:ESPathForDocuments() error:NULL][key];
}

- (long long)diskFreeSize
{
    return [[self es_attributeOfFileSystem:NSFileSystemFreeSize] longLongValue];
}

- (NSString *)diskFreeSizeString
{
    return [NSByteCountFormatter stringFromByteCount:self.diskFreeSize countStyle:NSByteCountFormatterCountStyleFile];
}

- (long long)diskSize
{
    return [[self es_attributeOfFileSystem:NSFileSystemSize] longLongValue];
}

- (NSString *)diskSizeString
{
    return [NSByteCountFormatter stringFromByteCount:self.diskSize countStyle:NSByteCountFormatterCountStyleFile];
}

- (CGSize)screenSizeInPoints
{
    return UIScreen.mainScreen.bounds.size;
}

- (CGSize)screenSizeInPixels
{
    return UIScreen.mainScreen.currentMode.size;
}

- (NSDictionary *)getNetworkInterfacesIncludesLoopback:(BOOL)includesLoopback
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

- (NSString *)localIPv4Address
{
    return [self getNetworkInterfacesIncludesLoopback:NO][kESNetworkInterfaceFamilyIPv4][kESNetworkInterfaceNameWiFi];
}

- (NSString *)localIPv6Address
{
    return [self getNetworkInterfacesIncludesLoopback:NO][kESNetworkInterfaceFamilyIPv6][kESNetworkInterfaceNameWiFi];
}

@end
