//
//  ESApp+Helper.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

#define kESUserDefaultsKey_CheckFreshLaunchAppVersion @"es_check_fresh_launch_app_version"

@implementation ESApp (Helper)

+ (BOOL)isFreshLaunch:(NSString **)previousAppVersion
{
        static NSString *__previousVersion = nil;
        static BOOL __isFreshLaunch = NO;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                __previousVersion = [NSUserDefaults objectForKey:kESUserDefaultsKey_CheckFreshLaunchAppVersion];
                NSString *current = [self appVersion];
                if (__previousVersion && [__previousVersion compare:current] == NSOrderedSame) {
                        __isFreshLaunch = NO;
                } else {
                        __isFreshLaunch = YES;
                        [NSUserDefaults setObject:current forKey:kESUserDefaultsKey_CheckFreshLaunchAppVersion];
                }
        });
        
        if (previousAppVersion) {
                *previousAppVersion = __previousVersion;
        }
        return __isFreshLaunch;
}

+ (void)deleteAllHTTPCookies
{
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *c in cookieStorage.cookies) {
                [cookieStorage deleteCookie:c];
        }
}

+ (void)simulateLowMemoryWarning
{
#if DEBUG
        SEL memoryWarningSel =  NSSelectorFromString(@"_performMemoryWarning");
        if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
                NSLogInfo(@"Simulate low memory warning");
                // Supress the warning. -Wundeclared-selector was used while ARC is enabled.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[UIApplication sharedApplication] performSelector:memoryWarningSel];
#pragma clang diagnostic pop
        } else {
                // UIApplication no loger responds to _performMemoryWarning
                exit(1);
        }
#endif
}

static UIBackgroundTaskIdentifier __es_gBackgroundTaskID = 0;
+ (void)enableMultitasking
{
        if (!__es_gBackgroundTaskID || __es_gBackgroundTaskID == UIBackgroundTaskInvalid) {
                __es_gBackgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                        ESDispatchAsyncOnMainThread(^{
                                if (UIBackgroundTaskInvalid != __es_gBackgroundTaskID) {
                                        [[UIApplication sharedApplication] endBackgroundTask:__es_gBackgroundTaskID];
                                        __es_gBackgroundTaskID = UIBackgroundTaskInvalid;
                                }
                                [[self class] enableMultitasking];
                        });
                }];
        }
}

+ (void)disableMultitasking
{
        ESDispatchSyncOnMainThread(^{
                if (__es_gBackgroundTaskID) {
                        [[UIApplication sharedApplication] endBackgroundTask:__es_gBackgroundTaskID];
                        __es_gBackgroundTaskID = UIBackgroundTaskInvalid;
                }
        });
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

+ (void)openAppReviewPageWithAppID:(NSString *)appID
{
        if ([appID isKindOfClass:[NSNumber class]]) {
                appID = [(NSNumber *)appID stringValue];
        }
        if (![appID isKindOfClass:[NSString class]] || appID.length < 8) {
                return;
        }
        NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
        [self openURLWithString:reviewURL];
}

@end
