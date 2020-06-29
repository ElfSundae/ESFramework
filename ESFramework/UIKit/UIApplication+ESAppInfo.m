//
//  UIApplication+AppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/13.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "UIApplication+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import <objc/runtime.h>
#import "UIDevice+ESExtension.h"
#import "ESNetworkHelper.h"

static const void *appNameKey = &appNameKey;
static const void *appChannelKey = &appChannelKey;

static NSDate *_gAppStartupDate = nil;
static NSString *_gAppPreviousVersion = nil;
static BOOL _gIsFreshLaunch = NO;

static void ESCheckAppFreshLaunch(void)
{
#define ESESCheckAppFreshLaunchKey @"ESAppCheckFreshLaunch"
    _gAppPreviousVersion = [NSUserDefaults.standardUserDefaults stringForKey:ESESCheckAppFreshLaunchKey];
    NSString *currentVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    _gIsFreshLaunch = !(_gAppPreviousVersion && [_gAppPreviousVersion isEqualToString:currentVersion]);

    if (_gIsFreshLaunch) {
        [NSUserDefaults.standardUserDefaults setObject:currentVersion forKey:ESESCheckAppFreshLaunchKey];
    }
#undef ESESCheckAppFreshLaunchKey
}

@implementation UIApplication (ESAppInfo)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gAppStartupDate = [NSDate date];

        ESCheckAppFreshLaunch();
    });
}

- (NSString *)appName
{
    NSString *appName = objc_getAssociatedObject(self, appNameKey);
    if (!appName) {
        appName = [NSBundle.mainBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleExecutableKey];
        appName = [appName stringByReplacingOccurrencesOfString:@"\\s+" withString:@"-" options:NSRegularExpressionSearch range:NSMakeRange(0, appName.length)];
    }
    return appName;
}

- (void)setAppName:(NSString *)appName
{
    objc_setAssociatedObject(self, appNameKey, appName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)appChannel
{
    return objc_getAssociatedObject(self, appChannelKey) ?: @"App Store";
}

- (void)setAppChannel:(NSString *)appChannel
{
    objc_setAssociatedObject(self, appChannelKey, appChannel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)appBundleName
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleNameKey];
}

- (NSString *)appDisplayName
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"] ?: self.appBundleName;
}

- (NSString *)appBundleIdentifier
{
    static NSString *_appBundleIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appBundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
    });
    return _appBundleIdentifier;
}

- (NSString *)appVersion
{
    static NSString *_appVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ?: @"";
    });
    return _appVersion;
}

- (NSString *)appBuildVersion
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleVersionKey] ?: @"";
}

- (NSString *)appFullVersion
{
    return [NSString stringWithFormat:@"%@ (%@)", self.appVersion, self.appBuildVersion];
}

- (nullable NSString *)appIconFilename
{
    NSArray *iconFiles = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    return iconFiles.firstObject;
}

- (nullable UIImage *)appIconImage
{
    NSString *iconFile = [self appIconFilename];
    if (!iconFile) {
        return nil;
    }

    iconFile = [NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:iconFile];
    return [UIImage imageWithContentsOfFile:iconFile];
}

- (NSDate *)appStartupDate
{
    return _gAppStartupDate;
}

- (NSTimeInterval)appUptime
{
    return fabs(self.appStartupDate.timeIntervalSinceNow);
}

- (BOOL)isFreshLaunch
{
    return _gIsFreshLaunch;
}

- (nullable NSString *)appPreviousVersion
{
    return _gAppPreviousVersion;
}

- (NSSet<NSString *> *)allURLSchemes
{
    NSMutableSet *result = [NSMutableSet set];

    for (NSDictionary *dict in [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"]) {
        NSArray *schemes = dict[@"CFBundleURLSchemes"];
        if ([schemes isKindOfClass:[NSArray class]]) {
            [result addObjectsFromArray:schemes];
        }
    }

    return [result copy];
}

- (NSSet<NSString *> *)URLSchemesForIdentifier:(nullable NSString *)identifier
{
    NSMutableSet *result = [NSMutableSet set];

    NSArray *urlTypes = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if ([urlTypes isKindOfClass:NSArray.class] && urlTypes.count) {
        NSPredicate *predicate = nil;
        if (identifier.length) {
            predicate = [NSPredicate predicateWithFormat:@"CFBundleURLName == %@", identifier];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"CFBundleURLName == NULL OR CFBundleURLName == ''"];
        }
        NSArray *filtered = [urlTypes filteredArrayUsingPredicate:predicate];
        for (NSDictionary *dict in filtered) {
            NSArray *schemes = dict[@"CFBundleURLSchemes"];
            if ([schemes isKindOfClass:[NSArray class]]) {
                [result addObjectsFromArray:schemes];
            }
        }
    }

    return [result copy];
}

- (NSDictionary *)analyticsInfo
{
    NSMutableDictionary *info = [NSMutableDictionary dictionary];

    UIDevice *device = UIDevice.currentDevice;
    info[@"os"] = device.systemName;
    info[@"os_version"] = device.systemVersion;
    info[@"model"] = device.model;
    info[@"model_identifier"] = device.modelIdentifier;
    info[@"model_name"] = device.modelName;
    info[@"device_name"] = device.name;
#if TARGET_OS_IOS
    info[@"jailbroken"] = @(device.isJailbroken);
#endif
    info[@"screen_width"] = @((NSInteger)device.screenSizeInPoints.width);
    info[@"screen_height"] = @((NSInteger)device.screenSizeInPoints.height);
    info[@"screen_scale"] = [NSString stringWithFormat:@"%.2f", UIScreen.mainScreen.scale];
    info[@"timezone_gmt"] = @(NSTimeZone.localTimeZone.secondsFromGMT);
    info[@"locale"] = NSLocale.currentLocale.localeIdentifier;

    info[@"app_name"] = self.appName;
    info[@"app_identifier"] = self.appBundleIdentifier;
    info[@"app_channel"] = self.appChannel;
    info[@"app_version"] = self.appVersion;
    info[@"app_build_version"] = self.appBuildVersion;
    info[@"app_uptime"] = [NSString stringWithFormat:@"%.2f", self.appUptime];
    if (self.isFreshLaunch) {
        info[@"app_fresh_launch"] = @YES;
        info[@"app_previous_version"] = self.appPreviousVersion;
    }

    NSString *ipv6 = nil;
    info[@"local_ip"] = [ESNetworkHelper getIPAddressForWiFi:&ipv6];
    info[@"local_ipv6"] = ipv6;

#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST
    ipv6 = nil;
    info[@"wwan_ip"] = [ESNetworkHelper getIPAddressForCellular:&ipv6];
    info[@"wwan_ipv6"] = ipv6;

    info[@"ssid"] = [ESNetworkHelper getWiFiSSID];
    info[@"bssid"] = [ESNetworkHelper getWiFiBSSID];
    info[@"carrier"] = [ESNetworkHelper getCarrierName];
    info[@"wwan"] = [ESNetworkHelper getCellularNetworkTypeString];
#endif

    return [info copy];
}

- (NSString *)userAgentForHTTPRequest
{
    UIDevice *device = UIDevice.currentDevice;
    NSString *userAgent = [NSString stringWithFormat:
                           @"%@/%@ (%@; %@ %@; Channel/%@; Scale/%.2f; Locale/%@)",
                           self.appName, self.appVersion,
                           device.model, device.systemName, device.systemVersion,
                           self.appChannel,
                           UIScreen.mainScreen.scale,
                           NSLocale.currentLocale.localeIdentifier];

    if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        NSMutableString *mutableUserAgent = [userAgent mutableCopy];
        if (CFStringTransform((__bridge CFMutableStringRef)mutableUserAgent, NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
            userAgent = mutableUserAgent;
        }
    }

    return userAgent;
}

@end

#endif
