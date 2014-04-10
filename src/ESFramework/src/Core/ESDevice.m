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
@import CoreGraphics;

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
                float t = size.width;
                size.width = size.height;
                size.height = t;
        }
        return [NSString stringWithFormat:@"%dx%d", (int)size.width, (int)size.height];
}

+ (BOOL)isRetinaScreen
{
        return ([UIScreen mainScreen].scale == 2.0);
}

+ (BOOL)isIPhoneRetina4InchScreen
{
        return CGSizeEqualToSize([self screenSize], CGSizeMake(640.f, 1136.f));
}

+ (BOOL)isIPhoneRetina35InchScreen
{
        return CGSizeEqualToSize([self screenSize], CGSizeMake(640.f, 960.f));
}
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
