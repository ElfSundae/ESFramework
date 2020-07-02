//
//  ESNetworkInfo+ESWiFiExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2020/07/03.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import "ESNetworkInfo.h"
#if TARGET_OS_IOS

#import <SystemConfiguration/CaptiveNetwork.h>

NSString *const ESNetworkInfoKeySSID = @"SSID";
NSString *const ESNetworkInfoKeyBSSID = @"BSSID";
NSString *const ESNetworkInfoKeySSIDData = @"SSIDDATA";

@implementation ESNetworkInfo (ESWiFiExtension)

+ (nullable NSDictionary<NSString *, id> *)WiFiNetworkInfo
{
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (!interfaces) {
        return nil;
    }

    NSDictionary *info = nil;

    CFIndex count = CFArrayGetCount(interfaces);
    for (CFIndex i = 0; i < count; ++i) {
        CFDictionaryRef networkInfo = CNCopyCurrentNetworkInfo((CFStringRef)CFArrayGetValueAtIndex(interfaces, i));
        if (networkInfo) {
            info = CFBridgingRelease(networkInfo);
            break;
        }
    }
    CFRelease(interfaces);

    return info;
}

@end

#endif
