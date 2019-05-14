//
//  UIApplication+AppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/13.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIApplication+ESAdditions.h"
#import "ESHelpers.h"
#import "ESValue.h"
#import "UIDevice+ESAdditions.h"
#import "ESNetworkHelper.h"
#import "AFNetworkReachabilityManager+ESAdditions.h"

#define ESAppPreviousVersionUserDefaultsKey @"ESAppCheckFreshLaunch"

static NSDate *_gAppLaunchDate = nil;
static NSString *_gAppPreviousVersion = nil;

static void ESCheckAppFreshLaunch(void)
{
    _gAppPreviousVersion = [NSUserDefaults.standardUserDefaults stringForKey:ESAppPreviousVersionUserDefaultsKey];
    NSString *currentVersion = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    if (!_gAppPreviousVersion || ![_gAppPreviousVersion isEqualToString:currentVersion]) {
        [NSUserDefaults.standardUserDefaults setObject:currentVersion forKey:ESAppPreviousVersionUserDefaultsKey];
    }
}

@implementation UIApplication (ESAppInfo)

+ (void)load
{
    _gAppLaunchDate = [NSDate date];

    [AFNetworkReachabilityManager.sharedManager startMonitoring];

    ESCheckAppFreshLaunch();
}

- (NSString *)appName
{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleExecutable"];
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
    return ESBoolValueWithDefault([NSBundle.mainBundle objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"], YES);
}

- (NSDate *)appLaunchDate
{
    return _gAppLaunchDate;
}

- (NSTimeInterval)appLaunchDuration
{
    return fabs(self.appLaunchDate.timeIntervalSinceNow);
}

- (BOOL)isFreshLaunch
{
    return !self.appPreviousVersion || ![self.appPreviousVersion isEqualToString:self.appVersion];
}

- (NSString *)appPreviousVersion
{
    return _gAppPreviousVersion;
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
    info[@"timezone_gmt"] = @(NSTimeZone.localTimeZone.secondsFromGMT / 3600);
    info[@"locale"] = NSLocale.currentLocale.localeIdentifier;

    info[@"app_name"] = self.appName;
    info[@"app_identifier"] = self.appBundleIdentifier;
    info[@"app_version"] = self.appVersion;
    info[@"app_build_version"] = self.appBuildVersion;
    info[@"app_launch"] = [NSString stringWithFormat:@"%.2f", self.appLaunchDuration];
    if (self.isFreshLaunch) {
        info[@"app_fresh_launch"] = @YES;
        info[@"app_previous_version"] = self.appPreviousVersion;
    }
    // info[@"app_channel"] = self.appChannel ?: @"";

    info[@"network"] = AFNetworkReachabilityManager.sharedManager.networkReachabilityStatusString;
    info[@"wwan"] = [ESNetworkHelper getCellularNetworkTypeString];

    NSString *carrier = [ESNetworkHelper getCarrierName];
    if (carrier) {
        info[@"carrier"] = carrier;
    }
    NSString *SSID = [ESNetworkHelper getWiFiSSID];
    if (SSID) {
        info[@"ssid"] = SSID;
    }
    NSString *BSSID = [ESNetworkHelper getWiFiBSSID];
    if (BSSID) {
        info[@"bssid"] = BSSID;
    }

    NSString *localIPv6 = nil;
    NSString *localIP = [ESNetworkHelper getIPAddressForWiFi:&localIPv6];
    if (localIP) {
        info[@"local_ip"] = localIP;
    }
    if (localIPv6) {
        info[@"local_ipv6"] = localIPv6;
    }

    return [info copy];
}

@end
