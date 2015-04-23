//
//  ESApp+AppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp+AppInfo.h"
#import "ESApp+Helper.h"
#import "ESApp+Subclassing.h"
#import "UIDevice+ESInfo.h"
#import "UIDevice+ESNetworkReachability.h"

ES_CATEGORY_FIX(ESApp_AppInfo)

@implementation ESApp (AppInfo)

+ (NSBundle *)mainBundle
{
        return [NSBundle mainBundle];
}

+ (NSDictionary *)infoDictionary
{
        return [[NSBundle mainBundle] infoDictionary];
}

+ (id)objectForInfoDictionaryKey:(NSString *)key
{
        return [[self mainBundle] objectForInfoDictionaryKey:key];
}

+ (NSString *)displayName
{
        NSString *result = [self objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        if (!result) {
                result = [self objectForInfoDictionaryKey:@"CFBundleName"];
        }
        return result ?: @"";
}

+ (NSString *)appVersion
{
        // version for displaying
        NSString *version = [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!ESIsStringWithAnyText(version)) {
                // build version
                version = [self objectForInfoDictionaryKey:@"CFBundleVersion"];
        }
        return version ?: @"";
}

+ (BOOL)isUIViewControllerBasedStatusBarAppearance
{
        static BOOL __isUIViewControllerBasedStatusBarAppearance = YES;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                id setting = [self objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
                if (setting) {
                        __isUIViewControllerBasedStatusBarAppearance = [setting boolValue];
                }
        });
        return __isUIViewControllerBasedStatusBarAppearance;
}

+ (NSString *)bundleIdentifier
{
        return [self objectForInfoDictionaryKey:@"CFBundleIdentifier"];
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
        //result[@"network"] = [UIDevice currentNetworkStatusString];
//        NSString *network = @"";
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//        if (ESInvokeSelector([UIDevice class], @selector(currentNetworkStatusString), &network) && network) {
//                result[@"network"] = network;
//        }
//#pragma clang diagnostic pop
        result[@"app_name"] = [self.class displayName];
        result[@"app_version"] = [self.class appVersion];
        result[@"app_identifier"] = [self.class bundleIdentifier];
        result[@"app_channel"] = self.appChannel;
        
        return (NSDictionary *)result;
}

- (NSString *)userAgentForWebView
{
        static NSString *__gUserAgentForWebView = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __gUserAgentForWebView = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU %@ %@ like Mac OS X) Mobile/%@ %@",
                                          [UIDevice model],
                                          (ESIsPhoneDevice() ? @"iPhone OS" : @"OS"),
                                          [[UIDevice systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"],
                                          [UIDevice systemBuildIdentifier],
                                          [self userAgent]];
        });
        return __gUserAgentForWebView;
}

- (NSString *)userAgent
{
        static NSString *__gUserAgent = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __gUserAgent = [NSString stringWithFormat:@"ESFramework(%@;%@;%@;%@;%@;%@;%@;%@)",
                                [UIDevice systemName],
                                [UIDevice systemVersion],
                                [self.class bundleIdentifier],
                                [self.class appVersion],
                                [self appChannel],
                                [UIDevice openUDID],
                                [UIDevice screenSizeString],
                                [UIDevice currentLocaleIdentifier]];
        });
        return __gUserAgent;
}

+ (NSArray *)URLSchemesForIdentifier:(NSString *)identifier
{
        NSArray *urlTypes = [self objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if (!ESIsArrayWithItems(urlTypes)) {
                return nil;
        }
        
        NSPredicate *predicate = nil;
        if (ESIsStringWithAnyText(identifier)) {
                predicate = [NSPredicate predicateWithFormat:@"SELF['CFBundleURLName'] == %@", identifier];
        } else {
                predicate = [NSPredicate predicateWithFormat:@"SELF['CFBundleURLName'] == NULL OR SELF['CFBundleURLName'] == ''"];
        }
        
        NSArray *filtered = [urlTypes filteredArrayUsingPredicate:predicate];
        
        NSDictionary *schemesDict = [filtered firstObject];
        if ([schemesDict isKindOfClass:[NSDictionary class]]) {
                NSArray *result = schemesDict[@"CFBundleURLSchemes"];
                if (ESIsArrayWithItems(result)) {
                        return result;
                }
        }
        
        return nil;
}
+ (NSArray *)URLSchemes
{
        return [self URLSchemesForIdentifier:nil];
}

+ (NSString *)URLSchemeForIdentifier:(NSString *)identifier
{
        return [[self URLSchemesForIdentifier:identifier] firstObject];
}
+ (NSString *)URLScheme
{
        return [self URLSchemeForIdentifier:nil];
}

@end
