//
//  UIApplication+AppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/13.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIApplication+ESAdditions.h"
#import "AFNetworkReachabilityManager+ESAdditions.h"
#import "ESMacros.h"
#import "ESHelpers.h"
#import "UIDevice+ESAdditions.h"
#import "ESNetworkHelper.h"
#import "NSTimeZone+ESAdditions.h"

NSString *const ESAppPreviousVersionUserDefaultsKey = @"ESAppCheckFreshLaunch";

ESDefineAssociatedObjectKey(appName)
ESDefineAssociatedObjectKey(appChannel)
ESDefineAssociatedObjectKey(appStoreID)

static NSDate *_gAppStartupDate = nil;
static NSString *_gAppPreviousVersion = nil;
static BOOL _gIsFreshLaunch = NO;

static void ESCheckAppFreshLaunch(void)
{
    _gAppPreviousVersion = [NSUserDefaults.standardUserDefaults stringForKey:ESAppPreviousVersionUserDefaultsKey];
    NSString *currentVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    _gIsFreshLaunch = !_gAppPreviousVersion || ![_gAppPreviousVersion isEqualToString:currentVersion];

    if (_gIsFreshLaunch) {
        [NSUserDefaults.standardUserDefaults setObject:currentVersion forKey:ESAppPreviousVersionUserDefaultsKey];
    }
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
    return (objc_getAssociatedObject(self, appNameKey)
            ?: [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleExecutable"]);
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

- (NSString *)appStoreID
{
    return objc_getAssociatedObject(self, appStoreIDKey);
}

- (void)setAppStoreID:(NSString *)appStoreID
{
    objc_setAssociatedObject(self, appStoreIDKey, appStoreID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)appBundleName
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)appDisplayName
{
    return ([NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"]
            ?: self.appBundleName);
}

- (NSString *)appBundleIdentifier
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (NSString *)appVersion
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)appBuildVersion
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)appFullVersion
{
    if (ESIsStringWithAnyText(self.appBuildVersion)) {
        return [NSString stringWithFormat:@"%@ (%@)", self.appVersion, self.appBuildVersion];
    }
    return self.appVersion;
}

- (BOOL)isUIViewControllerBasedStatusBarAppearance
{
    NSNumber *value = [NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    return value ? value.boolValue : YES;
}

- (nullable NSString *)appIconFile
{
    NSArray *iconFiles = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    return iconFiles.firstObject;
}

- (nullable UIImage *)appIconImage
{
    NSString *iconFile = [self appIconFile];
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

- (NSSet *)allURLSchemes
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

- (NSSet *)URLSchemesForIdentifier:(NSString *)identifier
{
    NSMutableSet *result = [NSMutableSet set];

    NSArray *urlTypes = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if (ESIsArrayWithItems(urlTypes)) {
        NSPredicate *predicate = nil;
        if (ESIsStringWithAnyText(identifier)) {
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
    info[@"timezone_gmt"] = @(NSTimeZone.localTimeZone.hoursFromGMT);
    info[@"locale"] = NSLocale.currentLocale.localeIdentifier;
    if (device.deviceTokenString) {
        info[@"device_token"] = device.deviceTokenString;
    }

    info[@"app_name"] = self.appName;
    info[@"app_identifier"] = self.appBundleIdentifier;
    info[@"app_channel"] = self.appChannel ?: @"";
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
            @"%@/%@ (%@; %@ %@; Channel/%@; Scale/%0.2f; Screen/%@; Locale/%@; Network/%@)",
            self.appName, self.appVersion,
            device.model, device.systemName, device.systemVersion,
            self.appChannel,
            UIScreen.mainScreen.scale,
            ESScreenSizeString(device.screenSizeInPoints),
            NSLocale.currentLocale.localeIdentifier,
            AFNetworkReachabilityManager.sharedManager.networkReachabilityStatusString];
}

@end
