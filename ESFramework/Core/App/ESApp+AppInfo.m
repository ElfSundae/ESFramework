//
//  ESApp+ESAppInfo.m
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"
#import "UIDevice+ESInfo.h"

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
        return [self objectForInfoDictionaryKey:@"CFBundleDisplayName"];
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

- (NSMutableDictionary *)analyticsInformation
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"os"] = [UIDevice systemName];
        result[@"os_version"] = [UIDevice systemVersion];
        result[@"model"] = [UIDevice model];
        result[@"name"] = [UIDevice name];
        result[@"platform"] = [UIDevice platform];
        result[@"carrier"] = [UIDevice carrierString];
        result[@"udid"] = [UIDevice openUDID];
        result[@"jailbroken"] = @([UIDevice isJailbroken] ? 1 : 0);
        result[@"screen_size"] = [UIDevice screenSizeString];
        result[@"timezone_gmt"] = @([UIDevice localTimeZoneFromGMT]);
        result[@"locale"] = [UIDevice currentLocaleIdentifier];
        NSString *network = @"";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        if (ESInvokeSelector([UIDevice class], @selector(currentNetworkStatusString), &network) && network) {
                result[@"network"] = network;
        }
#pragma clang diagnostic pop
        result[@"app_name"] = [self.class displayName];
        result[@"app_version"] = [self.class appVersion];
        result[@"app_identifier"] = [self.class bundleIdentifier];
        result[@"app_channel"] = self.appChannel;
        
        return result;
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
                                @"iOS",
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
        if (!urlTypes || !urlTypes.count) {
                return nil;
        }
        
        NSPredicate *predicate = nil;
        if ([identifier isKindOfClass:[NSString class]] && identifier.length) {
                predicate = [NSPredicate predicateWithFormat:@"SELF['CFBundleURLName'] == %@", identifier];
        } else {
                predicate = [NSPredicate predicateWithFormat:@"SELF['CFBundleURLName'] == NULL OR SELF['CFBundleURLName'] == ''"];
        }
        
        NSArray *filtered = [urlTypes filteredArrayUsingPredicate:predicate];
        
        NSDictionary *schemesDict = [filtered firstObject];
        if ([schemesDict isKindOfClass:[NSDictionary class]]) {
                NSArray *result = schemesDict[@"CFBundleURLSchemes"];
                if (result && result.count) {
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
