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
        NSString *version = [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!version || ![version length]) {
                version = [self objectForInfoDictionaryKey:@"CFBundleVersion"];
        }
        return (version ?: @"");
}

+ (NSString *)bundleIdentifier
{
        return [self objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)appChannel
{
        return @"App Store";
}

+ (NSMutableDictionary *)analyticsInformation
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        result[@"system"] = [UIDevice systemName];
        result[@"system_version"] = [UIDevice systemVersion];
        result[@"model"] = [UIDevice model];
        result[@"name"] = [UIDevice name];
        result[@"platform"] = [UIDevice platform];
        result[@"carrier"] = [UIDevice carrierString];
        result[@"udid"] = [UIDevice deviceIdentifier];
        result[@"jailbroken"] = [NSNumber numberWithInteger:([UIDevice isJailBroken] ? 1 : 0)];
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
        result[@"app_name"] = [self displayName];
        result[@"app_version"] = [self appVersion];
        result[@"app_identifier"] = [self bundleIdentifier];
        result[@"app_channel"] = [self appChannel];
        
        return result;
}

+ (NSString *)userAgent
{
        static NSString *__gUserAgent = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                NSString *ua = [NSUserDefaults objectForKey:@"UserAgent"];
                __gUserAgent = [NSString stringWithFormat:@"%@", ua];
        });
        NSLog(@"%@", __gUserAgent);
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
