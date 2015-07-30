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

ES_IMPLEMENTATION_CATEGORY_FIX(ESApp, AppInfo)

+ (id)objectForInfoDictionaryKey:(NSString *)key
{
        return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}

- (NSString *)appBundleIdentifier
{
        return [self.class objectForInfoDictionaryKey:@"CFBundleIdentifier"] ?: @"";
}

- (NSString *)appDisplayName
{
        NSString *result = [self.class objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (!result) {
                result = [self.class objectForInfoDictionaryKey:@"CFBundleName"];
        }
        return result ?: @"";
}

- (NSString *)appName
{
        NSString *result = [self.class objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleExecutableKey];
        if (!result) {
                result = [NSProcessInfo processInfo].processName;
        }
        if (!result) {
                result = self.appDisplayName;
        }
        return result ?: self.appBundleIdentifier;
}

- (NSString *)appVersion
{
        // version for displaying
        NSString *version = [self.class objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!ESIsStringWithAnyText(version)) {
                // build version
                version = [self.class objectForInfoDictionaryKey:@"CFBundleVersion"];
        }
        return version ?: @"1.0";
}

- (NSString *)appVersionWithBuildVersion
{
        NSString *version = [self.class objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *build = [self.class objectForInfoDictionaryKey:@"CFBundleVersion"];
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

- (BOOL)isUIViewControllerBasedStatusBarAppearance
{
        static BOOL __isUIViewControllerBasedStatusBarAppearance = YES;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                id setting = [self.class objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
                if (setting) {
                        __isUIViewControllerBasedStatusBarAppearance = [setting boolValue];
                }
        });
        return __isUIViewControllerBasedStatusBarAppearance;
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
        result[@"app_name"] = self.appName ?: @"";
        result[@"app_version"] = self.appVersion ?: @"";
        result[@"app_identifier"] = self.appBundleIdentifier ?: @"";
        result[@"app_channel"] = self.appChannel ?: @"";
        
        return (NSDictionary *)result;
}

- (NSString *)userAgent
{
        static NSString *__gUserAgent = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                // 以 '; ' 间隔
                NSMutableString *ua = [NSMutableString string];
                [ua appendFormat:@"%@/%@", self.appName, self.appVersion];
                [ua appendFormat:@" (%@; iOS %@; Scale/%0.2f; Screen/%@",
                 [UIDevice model],
                 [UIDevice systemVersion],
                 [UIScreen mainScreen].scale,
                 [UIDevice screenSizeString]];
                [ua appendFormat:@"; Locale/%@", [UIDevice currentLocaleIdentifier]];
                if (ESIsStringWithAnyText(self.appChannel)) {
                        [ua appendFormat:@"; Channel/%@", self.appChannel];
                }
                if ([UIDevice openUDID]) {
                        [ua appendFormat:@"; OpenUDID/%@", [UIDevice openUDID]];
                }
                [ua appendFormat:@")"];
                
                __gUserAgent = (NSString *)ua;
        });
        return __gUserAgent;
}

+ (NSString *)defaultUserAgentOfWebView
{
        return [ESApp sharedApp]->_esWebViewDefaultUserAgent;
}

- (NSString *)userAgentForWebView
{
        static NSString *__gUserAgentForWebView = nil;
        if (nil == __gUserAgentForWebView) {
                NSMutableString *ua = [NSMutableString string];
                NSString *defaultUA = [self.class defaultUserAgentOfWebView];
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
                
                // 如果已经获取到默认的ua, 则静态化当前值
                if (defaultUA) {
                        __gUserAgentForWebView = (NSString *)ua;
                } else {
                        // 否则，每次都计算，直到defaultUA获取到
                        return (NSString *)ua;
                }
        }
        return __gUserAgentForWebView;
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
