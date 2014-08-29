//
//  ESApp+Helper.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"
#import "NSString+ESAdditions.h"
#import "UIAlertView+ESBlock.h"
@import AddressBook;

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
                printf("Simulate low memory warning\n");
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

+ (BOOL)isMultitaskingEnabled
{
        return (__es_gBackgroundTaskID && __es_gBackgroundTaskID != UIBackgroundTaskInvalid);
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

+ (BOOL)openURLWithString:(NSString *)string
{
        return [self openURL:NSURLWith(string)];
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

+ (void)openAppReviewPage
{
        [self openAppReviewPageWithAppID:[[self sharedApp] appID]];
}

+ (void)openAppReviewPageWithAppID:(NSString *)appID
{
        if ([appID isKindOfClass:[NSNumber class]]) {
                appID = [(NSNumber *)appID stringValue];
        }
        
        [self openURL:NSURLWith([appID appReviewLinkForAppStore])];
}

+ (void)openAppStore
{
        [self openAppStoreWithAppID:[[self sharedApp] appID]];
}

+ (void)openAppStoreWithAppID:(NSString *)appID
{
        if ([appID isKindOfClass:[NSNumber class]]) {
                appID = [(NSNumber *)appID stringValue];
        }
        [self openURL:NSURLWith([appID appLinkForAppStore])];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - App Upgrade

- (void)showAppUpdateAlert:(ESAppUpdateObject *)updateObject alertMask:(ESAppUpdateAlertMask)alertMask handler:(BOOL (^)(ESAppUpdateObject *updateObject_, BOOL alertCanceld))handler
{
        if (![updateObject isKindOfClass:[ESAppUpdateObject class]] ||
            !ESMaskIsSet(alertMask, updateObject.updateResult)) {
                return;
        }
        
        ESWeak(self, _self);
        if (ESAppUpdateResultNone == updateObject.updateResult) {
                UIAlertView *alert =
                [UIAlertView alertViewWithTitle:updateObject.alertTitle
                                        message:updateObject.alertMessage
                              cancelButtonTitle:updateObject.alertCancelButtonTitle
                                didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        if (handler) {
                                                handler(updateObject, NO);
                                        }
                                } otherButtonTitles:nil];
                [alert show];
        } else if (ESAppUpdateResultOptional == updateObject.updateResult) {
                UIAlertView *alert =
                [UIAlertView alertViewWithTitle:updateObject.alertTitle
                                        message:updateObject.alertMessage
                              cancelButtonTitle:updateObject.alertUpdateButtonTitle
                                didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        BOOL alertCanceld = (buttonIndex != alertView.cancelButtonIndex);
                                        if ((!handler && !alertCanceld) ||
                                            (handler && handler(updateObject, alertCanceld))) {
                                              [[_self class] openURLWithString:updateObject.updateURL];
                                        }
                                } otherButtonTitles:updateObject.alertCancelButtonTitle, nil];
                [alert show];
        } else if (ESAppUpdateResultForced == updateObject.updateResult) {
                UIAlertView *alert =
                [UIAlertView alertViewWithTitle:updateObject.alertTitle
                                        message:updateObject.alertMessage
                              cancelButtonTitle:updateObject.alertUpdateButtonTitle
                                didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                        if (!handler ||
                                            (handler && handler(updateObject, NO))) {
                                                [[_self class] openURL:NSURLWith(updateObject.updateURL)];
                                                exit(0);
                                        }
                                } otherButtonTitles:nil];
                [alert show];
        }
}

- (void)showAppUpdateAlert:(ESAppUpdateAlertMask)alertMask
{
        [self showAppUpdateAlert:self.appUpdateSharedObject alertMask:alertMask];
}

- (void)checkForcedAppUpdateExists:(BOOL (^)(ESAppUpdateObject *))handler
{
        if ([[self class] isFreshLaunch:nil] ||
            self.appUpdateSharedObject.updateResult != ESAppUpdateResultForced) {
                if (handler) {
                        handler(nil);
                }
                return;
        }
        
        if (!handler ||
            (handler && handler(self.appUpdateSharedObject))) {
                [self showAppUpdateAlert:ESAppUpdateAlertMaskOnlyForced];
        }
        
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Authorization

- (void)requestAddressBookAccessWithCompletion:(ESBasicBlock)completion failure:(ESBasicBlock)failure
{
        if (!ABAddressBookRequestAccessWithCompletion) {
                if (completion) ESDispatchAsyncOnMainThread(completion);
                return;
        }
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (kABAuthorizationStatusAuthorized == status) {
                if (completion) ESDispatchAsyncOnMainThread(completion);
        } else if (kABAuthorizationStatusNotDetermined == status) {
                ABAddressBookRef addressBook = ABAddressBookCreate();
                ABAddressBookRequestAccessWithCompletion(ABAddressBookCreate(), ^(bool granted, CFErrorRef error) {
                        if (addressBook) {
                                CFRelease(addressBook);
                        }
                        if (granted) {
                                if (completion) ESDispatchAsyncOnMainThread(completion);
                        } else {
                                if (failure) ESDispatchAsyncOnMainThread(failure);
                        }
                });
        } else {
                if (failure) ESDispatchAsyncOnMainThread(failure);
        }
}

@end
