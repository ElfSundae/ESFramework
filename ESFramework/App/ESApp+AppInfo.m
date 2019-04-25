//
//  ESApp+AppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "ESHelpers.h"
#import "ESApp.h"
#import "ESValue.h"
#import "UIDevice+ESInfo.h"
#import "AFNetworkReachabilityManager+ESAdditions.h"
#import "_ESWebViewUserAgentFetcher.h"

static NSDate *__gAppLaunchDate = nil;

@implementation ESApp (_AppInfo)

+ (void)load
{
    __gAppLaunchDate = [NSDate date];

    @autoreleasepool {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
}

+ (id)objectForInfoDictionaryKey:(NSString *)key
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

+ (NSString *)appBundleIdentifier
{
    return [self objectForInfoDictionaryKey:@"CFBundleIdentifier"] ?: @"";
}

+ (NSString *)appVersion
{
    NSString *version = ESStringValueWithDefault([self objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                                 [self objectForInfoDictionaryKey:@"CFBundleVersion"]);
    return version ?: @"1.0";
}

+ (NSString *)appBuildVersion
{
    return ESStringValueWithDefault([self objectForInfoDictionaryKey:@"CFBundleVersion"], @"1");
}

+ (NSString *)appVersionWithBuildVersion
{
    return [NSString stringWithFormat:@"%@ (%@)", [self appVersion], [self appBuildVersion]];
}

+ (BOOL)isUIViewControllerBasedStatusBarAppearance
{
    return ESBoolValueWithDefault([self objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"],
                                  YES);
}

+ (NSDate *)appLaunchDate
{
    return __gAppLaunchDate ?: (__gAppLaunchDate = [NSDate date]);
}

+ (NSTimeInterval)appLaunchDuration
{
    return fabs([[self appLaunchDate] timeIntervalSinceNow]);
}

- (NSString *)appName
{
    return ESStringValueWithDefault([[self class] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleExecutableKey],
                                    [NSProcessInfo processInfo].processName);
}

- (NSString *)appDisplayName
{
    return ESStringValueWithDefault([[self class] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                                    [[self class] objectForInfoDictionaryKey:@"CFBundleName"]);
}

- (NSDictionary *)analyticsInformation
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    UIDevice *device = UIDevice.currentDevice;
    result[@"os"] = [device systemName];
    result[@"os_version"] = [device systemVersion];
    result[@"model"] = [device model];
    result[@"platform"] = [device platform];
    result[@"name"] = [device name];
    result[@"jailbroken"] = [device isJailbroken] ? @1 : @0;
    result[@"screen_size"] = ESScreenSizeString(device.screenSizeInPoints);
    result[@"screen_scale"] = [NSString stringWithFormat:@"%.2f", [UIScreen mainScreen].scale];
    result[@"timezone_gmt"] = @([device localTimeZoneFromGMT]);
    result[@"locale"] = [device currentLocaleIdentifier];
    NSString *carrier = [device carrierName];
    if (carrier) {
        result[@"carrier"] = carrier;
    }
    result[@"network"] = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatusString;
    NSString *ssid = [device WiFiSSID];
    if (ssid) {
        result[@"ssid"] = ssid;
    }
    NSString *localIP = [device localIPv4Address] ?: [device localIPv6Address];
    if (localIP) {
        result[@"local_ip"] = localIP;
    }

    result[@"app_name"] = self.appName;
    result[@"app_identifier"] = [[self class] appBundleIdentifier];
    result[@"app_version"] = [[self class] appVersion];
    result[@"app_build_version"] = [[self class] appBuildVersion];
    result[@"app_channel"] = self.appChannel ?: @"";
    result[@"app_launch"] = [NSString stringWithFormat:@"%.2f", [[self class] appLaunchDuration]];

    NSString *__autoreleasing previousAppVersion = nil;
    if ([[self class] isFreshLaunch:&previousAppVersion]) {
        result[@"app_fresh_launch"] = @(YES);
        if (previousAppVersion) {
            result[@"app_previous_version"] = previousAppVersion;
        }
    }

    return [result copy];
}

- (NSString *)userAgent
{
    // Split with '; '
    NSMutableString *ua = [NSMutableString string];
    [ua appendFormat:@"%@/%@", self.appName, [[self class] appVersion]];
    [ua appendFormat:@" (%@; %@ %@; Scale/%0.2f; Screen/%@",
     [UIDevice.currentDevice model],
     [UIDevice.currentDevice systemName],
     [UIDevice.currentDevice systemVersion],
     [UIScreen mainScreen].scale,
     ESScreenSizeString(UIDevice.currentDevice.screenSizeInPoints)];
    [ua appendFormat:@"; Locale/%@", [UIDevice.currentDevice currentLocaleIdentifier]];
    [ua appendFormat:@"; Network/%@", [AFNetworkReachabilityManager sharedManager].networkReachabilityStatusString];
    if (self.appChannel) {
        [ua appendFormat:@"; Channel/%@", self.appChannel];
    }
    [ua appendFormat:@")"];
    return [ua copy];
}

+ (NSString *)defaultUserAgentOfWebView
{
    return [_ESWebViewUserAgentFetcher defaultUserAgent];
}

- (NSString *)userAgentForWebView
{
    NSMutableString *ua = [NSMutableString string];
    NSString *defaultUA = [[self class] defaultUserAgentOfWebView];
    NSString *myUserAgent = self.userAgent;
    if (defaultUA) {
        [ua appendString:defaultUA];
    } else {
        [ua appendFormat:@"Mozilla/5.0 (%@; CPU %@ %@ like Mac OS X) AppleWebKit/%@ (KHTML, like Gecko) Mobile/%@",
         [UIDevice.currentDevice model],
         (ESIsPhoneDevice() ? @"iPhone OS" : @"OS"),
         [[UIDevice.currentDevice systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"],
         @"600.1.4",
         @"15E148"];
    }
    if (myUserAgent) {
        [ua appendFormat:@" %@", myUserAgent];
    }
    return [ua copy];
}

+ (NSArray *)URLSchemesForIdentifier:(NSString *)identifier
{
    NSMutableArray *result = [NSMutableArray array];

    NSArray *urlTypes = [self objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if (ESIsArrayWithItems(urlTypes)) {
        NSPredicate *predicate = nil;
        if (ESIsStringWithAnyText(identifier)) {
            predicate = [NSPredicate predicateWithFormat:@"SELF['CFBundleURLName'] == %@", identifier];
        } else {
            predicate = [NSPredicate predicateWithFormat:@"SELF['CFBundleURLName'] == NULL OR SELF['CFBundleURLName'] == ''"];
        }

        NSArray *filtered = [urlTypes filteredArrayUsingPredicate:predicate];
        for (NSDictionary *dict in filtered) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSArray *schemes = dict[@"CFBundleURLSchemes"];
                if (ESIsArrayWithItems(schemes)) {
                    [result addObjectsFromArray:schemes];
                }
            }
        }
    }

    return [result copy];
}

+ (NSArray *)allURLSchemes
{
    NSMutableArray *result = [NSMutableArray array];

    NSArray *urlTypes = [self objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if (ESIsArrayWithItems(urlTypes)) {
        for (NSDictionary *dict in urlTypes) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSArray *schemes = dict[@"CFBundleURLSchemes"];
                if (ESIsArrayWithItems(schemes)) {
                    [result addObjectsFromArray:schemes];
                }
            }
        }
    }

    return [result copy];
}

@end
