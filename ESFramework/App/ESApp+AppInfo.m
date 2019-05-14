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
#import "UIDevice+ESAdditions.h"
#import "AFNetworkReachabilityManager+ESAdditions.h"
#import "_ESWebViewUserAgentFetcher.h"
#import "ESNetworkHelper.h"
#import "UIApplication+ESAdditions.h"

@implementation ESApp (_AppInfo)

+ (NSString *)defaultUserAgentOfWebView
{
    return [_ESWebViewUserAgentFetcher defaultUserAgent];
}

- (NSString *)userAgentForWebView
{
    NSMutableString *ua = [NSMutableString string];
    NSString *defaultUA = [[self class] defaultUserAgentOfWebView];
    NSString *myUserAgent = UIApplication.sharedApplication.userAgentForHTTPRequest;
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

    NSArray *urlTypes = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"];
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

    NSArray *urlTypes = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"];
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
