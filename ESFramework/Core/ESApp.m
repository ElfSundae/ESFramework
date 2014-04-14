//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@implementation ESApp

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

ES_SINGLETON_IMP(sharedApp);

+ (void)load
{
        [self sharedApp];
}

- (id)init
{
        self = [super init];
        if (self) {
                [[self class] isFreshLaunch:nil];
                [self enableMultitasking];
        }
        return self;
}

- (void)enableMultitasking
{
        ES_WEAK_VAR(self, _self);
        if (!_backgroundTaskID || _backgroundTaskID == UIBackgroundTaskInvalid) {
                _backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                        ESDispatchAsyncOnMainThread(^{
                                if (UIBackgroundTaskInvalid != _backgroundTaskID) {
                                        [[UIApplication sharedApplication] endBackgroundTask:_backgroundTaskID];
                                        _backgroundTaskID = UIBackgroundTaskInvalid;
                                }
                                
                                [_self enableMultitasking];
                        });
                }];
        }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - App Info

+ (NSBundle *)mainBundle
{
        return [NSBundle mainBundle];
}

+ (NSDictionary *)infoDictionary
{
        return [[NSBundle mainBundle] infoDictionary];
}

+ (NSString *)displayName
{
        return [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)appVersion
{
        NSString *version = [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!version || ![version length]) {
                version = [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        }
        return (version ?: @"");
}

+ (NSString *)bundleIdentifier
{
        return [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSArray *)URLSchemesForIdentifier:(NSString *)identifier
{
        NSArray *urlTypes = [[self mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - OpenURL

+ (BOOL)canOpenURL:(NSURL *)url
{
        return [[UIApplication sharedApplication] canOpenURL:url];
}

+ (BOOL)openURL:(NSURL *)url
{
        if ([self canOpenURL:url]) {
                return [[UIApplication sharedApplication] openURL:url];
        }
        return NO;
}

+ (BOOL)openURLWithString:(NSString *)urlString
{
        return [self openURL:[NSURL URLWithString:urlString]];
}

+ (BOOL)canOpenPhoneCall
{
        return [self canOpenURL:[NSURL URLWithString:@"tel:"]];
}
+ (BOOL)openPhoneCall:(NSString *)phoneNumber returnToAppAfterCall:(BOOL)shouldReturn
{
        if (![phoneNumber isKindOfClass:[NSString class]] || !phoneNumber.length) {
                return NO;
        }
        
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", (phoneNumber ?: @"")]];
        if ([self canOpenURL:telURL]) {
                if (shouldReturn) {
                        static UIWebView *__sharedPhoneCallWebView = nil;
                        static dispatch_once_t onceToken;
                        dispatch_once(&onceToken, ^{
                                __sharedPhoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
                        });
                        [__sharedPhoneCallWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
                        return YES;
                } else {
                        [self openURL:telURL];
                }
        }
        return NO;
}

@end
