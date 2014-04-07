//
//  ESDevice.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESDevice.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
@import CoreTelephony;

@implementation ESDevice

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
+ (NSString *)model
{
        return [[UIDevice currentDevice] model];
}
+ (NSString *)platform
{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
        return platform;
}

+ (NSString *)carrierString
{
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier_t = [netInfo subscriberCellularProvider];
        NSString *carrier = [carrier_t carrierName];
        return carrier ?: @"";
}

+ (NSString *)deviceIdentifier
{
#if !TARGET_IPHONE_SIMULATOR
        Class openUDIDClass = NSClassFromString(@"OpenUDID");
        if (openUDIDClass) {
                return (NSString *)ESInvokeSelector(openUDIDClass, @selector(value), nil);
        }
#endif
        return @"0000000000000000000000000000000000000000";
}

+ (BOOL)isJailBroken
{
        static NSArray *__jbAppPaths = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __jbAppPaths = @[@"/Application/Cydia.app",
                             @"/Application/limera1n.app",
                             @"/Application/greenpois0n.app",
                             @"/Application/blackra1n.app",
                             @"/Application/blacksn0w.app",
                             @"/Application/redsn0w.app",
                             @"/private/var/lib/apt/",
                             ];

        });
        for (NSString *path in __jbAppPaths) {
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        return YES;
                }
        }
        if (0 == system("ls")) {
                return YES;
        }
        
        return NO;
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


//
//+ (CGSize)screenSize
//{
//        CGSize size = [UIScreen mainScreen].bounds.size;
//        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//        {
//                CGFloat scale = [[UIScreen mainScreen] scale];
//                size = CGSizeMake(size.width*scale, size.height*scale);
//        }
//        return size;
//}
//
//+ (NSString *)screenSizeString
//{
//        CGSize screenSize = [self screenSize];
//        if (screenSize.width > screenSize.height)
//        {
//                float tHeight = screenSize.width;
//                screenSize.width = screenSize.height;
//                screenSize.height = tHeight;
//        }
//        return [NSString stringWithFormat:@"%dx%d",
//                (int)screenSize.width,
//                (int)screenSize.height];
//}
//
//+ (BOOL)isRetinaScreen
//{
//        if ([[[UIDevice currentDevice] systemVersion] intValue] >= 4 &&
//            [[UIScreen mainScreen] scale] == 2.0)
//        {
//                return YES;
//        }
//        return NO;
//}
//
//+ (BOOL)isIPhoneRetina4Screen
//{
//        UIScreen *mainScreen = [UIScreen mainScreen];
//        CGFloat scale = [mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f;
//        CGFloat pixelHeight = CGRectGetHeight(mainScreen.bounds) * scale;
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
//            scale == 2.0 &&
//            pixelHeight == 1136.0)
//        {
//                return YES;
//        }
//        return NO;
//}
//
//+ (ESDeviceScreenType)deviceScreenType
//{
//        if ([self isIPhoneRetina4Screen]) {
//                return ESDeviceScreenTypeRetina4inch;
//        } else if ([self isRetinaScreen]) {
//                return ESDeviceScreenTypeRetina;
//        } else {
//                return ESDeviceScreenTypeNoRetina;
//        }
//}
//
//

//
//
//+ (ESNetworkStatus)currentNetworkStatus
//{
//        ESNetworkStatus result = ESNetworkStatusNotReachable;
//        NetworkStatus status = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
//        if (kReachableViaWiFi == status) {
//                result = ESNetworkStatusViaWiFi;
//        } else if (kReachableViaWWAN == status) {
//                result = ESNetworkStatusViaWWAN;
//        }
//        return result;
//}
//
//+ (NSString *)currentNetworkStatus_string;
//{
//        NSString *network = @"None";
//        ESNetworkStatus status = [self currentNetworkStatus];
//        if (ESNetworkStatusViaWiFi == status) {
//                network = @"WiFi";
//        } else if (kReachableViaWWAN == status) {
//                network = @"WWAN";
//        }
//        return network;
//}
//
//

@end
