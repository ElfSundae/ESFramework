//
//  UIApplication+AppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/13.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIApplication+ESExtension.h"
#import <AFNetworkingExtension/AFNetworkReachabilityManager+ESExtension.h>
#import "ESHelpers.h"
#import "UIDevice+ESExtension.h"
#import "ESNetworkHelper.h"

ESDefineAssociatedObjectKey(appName)
ESDefineAssociatedObjectKey(appChannel)

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

        [AFNetworkReachabilityManager.sharedManager startMonitoring];

        ESCheckAppFreshLaunch();
    });
}

- (NSString *)appName
{
    NSString *appName = objc_getAssociatedObject(self, appNameKey);
    if (!appName) {
        appName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleExecutable"];
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
    return objc_getAssociatedObject(self, appChannelKey) ?: @"AppStore";
}

- (void)setAppChannel:(NSString *)appChannel
{
    objc_setAssociatedObject(self, appChannelKey, appChannel, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)appBundleName
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
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
        _appBundleIdentifier = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    });
    return _appBundleIdentifier;
}

- (NSString *)appVersion
{
    static NSString *_appVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    });
    return _appVersion;
}

- (NSString *)appBuildVersion
{
    static NSString *_appBuildVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _appBuildVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"] ?: @"1";
    });
    return _appBuildVersion;
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

- (NSString *)appPreviousVersion
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
    info[@"jailbroken"] = @(device.isJailbroken);
    info[@"screen_size"] = ESScreenSizeString(device.screenSizeInPoints);
    info[@"screen_scale"] = [NSString stringWithFormat:@"%.2f", UIScreen.mainScreen.scale];
    info[@"timezone_gmt"] = @(NSTimeZone.localTimeZone.secondsFromGMT);
    info[@"locale"] = NSLocale.currentLocale.localeIdentifier;
    if (device.deviceTokenString) {
        info[@"device_token"] = device.deviceTokenString;
    }

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

    info[@"network"] = AFNetworkReachabilityManager.sharedManager.networkReachabilityStatusString;
    info[@"wwan"] = [ESNetworkHelper getCellularNetworkTypeString];

    NSString *carrier = [ESNetworkHelper getCarrierName];
    if (carrier) info[@"carrier"] = carrier;

    NSString *SSID = [ESNetworkHelper getWiFiSSID];
    if (SSID) info[@"ssid"] = SSID;
    NSString *BSSID = [ESNetworkHelper getWiFiBSSID];
    if (BSSID) info[@"bssid"] = BSSID;

    NSString *ipv6 = nil;
    NSString *ip = [ESNetworkHelper getIPAddressForWiFi:&ipv6];
    if (ip) info[@"local_ip"] = ip;
    if (ipv6) info[@"local_ipv6"] = ipv6;
    ip = [ESNetworkHelper getIPAddressForCellular:&ipv6];
    if (ip) info[@"wwan_ip"] = ip;
    if (ipv6) info[@"wwan_ipv6"] = ipv6;

    return [info copy];
}

- (NSString *)userAgentForHTTPRequest
{
    UIDevice *device = UIDevice.currentDevice;
    return [NSString stringWithFormat:
            @"%@/%@ (%@; %@ %@; Channel/%@; Screen/%@; Scale/%.2f; Locale/%@)",
            self.appName, self.appVersion,
            device.model, device.systemName, device.systemVersion,
            self.appChannel,
            ESScreenSizeString(device.screenSizeInPoints),
            UIScreen.mainScreen.scale,
            NSLocale.currentLocale.localeIdentifier];
}

@end
