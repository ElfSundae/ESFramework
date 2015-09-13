//
//  ESApp+AppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import "ESApp+Private.h"
#import "UIDevice+ESInfo.h"
#import "UIDevice+ESNetworkReachability.h"

@implementation ESApp (AppInfo)

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
        // version for displaying
        NSString *version = [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!ESIsStringWithAnyText(version)) {
                // build version
                version = [self objectForInfoDictionaryKey:@"CFBundleVersion"];
        }
        return version ?: @"1.0";
}

+ (NSString *)appVersionWithBuildVersion
{
        NSString *version = [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *build = [self objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSMutableString *result = [NSMutableString string];
        if (ESIsStringWithAnyText(version)) {
                [result appendString:version];
        }
        if (ESIsStringWithAnyText(build)) {
                if (result.length) {
                        [result appendFormat:@" (%@)", build];
                } else {
                        [result appendString:build];
                }
        }
        return result;
}

+ (BOOL)isUIViewControllerBasedStatusBarAppearance
{
        NSNumber *value = [self objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
        return value ? value.boolValue : YES;
}

- (NSString *)appName
{
        NSString *result = [[self class] objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleExecutableKey];
        if (!result) {
                result = [NSProcessInfo processInfo].processName;
        }
        return result ?: self.appDisplayName;
}

- (NSString *)appDisplayName
{
        NSString *result = [[self class] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (!result) {
                result = [[self class] objectForInfoDictionaryKey:@"CFBundleName"];
        }
        return result ?: @"";
}


- (NSDictionary *)analyticsInformation
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"os"] = [UIDevice systemName];
        result[@"os_version"] = [UIDevice systemVersion];
        result[@"model"] = [UIDevice model];
        result[@"name"] = [UIDevice name];
        result[@"platform"] = [UIDevice platform];
        result[@"carrier"] = [UIDevice carrierString];
        result[@"open_udid"] = [UIDevice openUDID];
        result[@"jailbroken"] = @([UIDevice isJailbroken] ? 1 : 0);
        result[@"screen_size"] = [UIDevice screenSizeString];
        result[@"timezone_gmt"] = @([UIDevice localTimeZoneFromGMT]);
        result[@"locale"] = [UIDevice currentLocaleIdentifier];
        result[@"network"] = [UIDevice currentNetworkReachabilityStatusString];
        result[@"app_name"] = self.appName;
        result[@"app_version"] = [[self class] appVersion];
        NSString *previousAppVersion = nil;
        if ([[self class] isFreshLaunch:&previousAppVersion]) {
                result[@"app_fresh_launch"] = @(YES);
                if (previousAppVersion) {
                        result[@"app_previous_version"] = previousAppVersion;
                }
        }
        result[@"app_identifier"] = [[self class] appBundleIdentifier];
        result[@"app_channel"] = self.appChannel ?: @"";
        
        return (NSDictionary *)result;
}

- (NSString *)userAgent
{
        // 以 '; ' 间隔
        NSMutableString *ua = [NSMutableString string];
        [ua appendFormat:@"%@/%@", self.appName, [[self class] appVersion]];
        [ua appendFormat:@" (%@; iOS %@; Scale/%0.2f; Screen/%@",
         [UIDevice model],
         [UIDevice systemVersion],
         [UIScreen mainScreen].scale,
         [UIDevice screenSizeString]];
        [ua appendFormat:@"; Locale/%@", [UIDevice currentLocaleIdentifier]];
        [ua appendFormat:@"; Network/%@", [UIDevice currentNetworkReachabilityStatusString]];
        if (ESIsStringWithAnyText(self.appChannel)) {
                [ua appendFormat:@"; Channel/%@", self.appChannel];
        }
        if ([UIDevice openUDID]) {
                [ua appendFormat:@"; OpenUDID/%@", [UIDevice openUDID]];
        }
        [ua appendFormat:@")"];
        return (NSString *)ua;
}

+ (NSString *)defaultUserAgentOfWebView
{
        return [ESApp sharedApp]->_esWebViewDefaultUserAgent;
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
                 [UIDevice model],
                 (ESIsPhoneDevice() ? @"iPhone OS" : @"OS"),
                 [[UIDevice systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"],
                 @"600.1.4",
                 [UIDevice systemBuildIdentifier]];
        }
        if (myUserAgent) {
                [ua appendFormat:@" %@", myUserAgent];
        }
        return (NSString *)ua;
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
        
        return (NSArray *)result;
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
        
        return (NSArray *)result;
}

@end
