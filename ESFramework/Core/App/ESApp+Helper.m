//
//  ESApp+Helper.m
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp+Helper.h"
#import "NSString+ESAdditions.h"
#import "UIAlertView+ESBlock.h"
@import AddressBook;
#import "ESApp+AppInfo.h"
#import "ESApp+Subclassing.h"

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
        SEL memoryWarningSel =  NSSelectorFromString(@"_performMemoryWarning");
        if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
                printf("Simulate low memory warning\n");
                // Supress the warning. -Wundeclared-selector was used while ARC is enabled.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[UIApplication sharedApplication] performSelector:memoryWarningSel];
#pragma clang diagnostic pop
        } else {
                printf("UIApplication no longer responds \"_performMemoryWarning\" selector.\n");
                // UIApplication no loger responds to _performMemoryWarning
                exit(1);
        }
}

static UIBackgroundTaskIdentifier __es_gBackgroundTaskID = 0;
+ (void)enableMultitasking
{
        if (!__es_gBackgroundTaskID || __es_gBackgroundTaskID == UIBackgroundTaskInvalid) {
                __es_gBackgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                        ESDispatchOnMainThreadAsynchrony(^{
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
        ESDispatchOnMainThreadSynchrony(^{
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
#pragma mark - UI

+ (UIWindow *)keyWindow
{
        static UIWindow *__gKeyWindow = nil;
        if (!__gKeyWindow) {
                id delegate = [UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(window)]) {
                        __gKeyWindow = (UIWindow *)[delegate valueForKey:@"window"];
                }
        }
        
        if (!__gKeyWindow) {
                // maybe the #keyWindow just is a temporary keyWindow,
                // so we do not save it to the #__gKeyWindow.
                return [UIApplication sharedApplication].keyWindow;
        }
        return __gKeyWindow;
}

- (UIWindow *)keyWindow
{
        return [[self class] keyWindow];
}

+ (void)dismissKeyboard
{
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

+ (UIViewController *)rootViewController
{
        return [self keyWindow].rootViewController;
}

+ (UIViewController *)rootViewControllerForPresenting
{
        UIViewController *rootViewController = [self rootViewController];
        
        while ([rootViewController.presentedViewController isKindOfClass:[UIViewController class]]) {
                rootViewController = rootViewController.presentedViewController;
        }
        
        return rootViewController;
}

- (UIViewController *)rootViewControllerForPresenting
{
        return [[self class] rootViewControllerForPresenting];
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion
{
        [[self rootViewControllerForPresenting] presentViewController:viewControllerToPresent animated:flag completion:completion];
}

+ (void)dismissAllViewControllersAnimated: (BOOL)flag completion: (void (^)(void))completion
{
        [[self rootViewController] dismissViewControllerAnimated:flag completion:completion];
}

+ (BOOL)isInForeground
{
        return ([UIApplication sharedApplication].applicationState == UIApplicationStateActive);
}

- (BOOL)isInForeground
{
        return [[self class] isInForeground];
}

+ (void)clearApplicationIconBadgeNumber
{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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

#if 0
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
#endif
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Authorization

- (void)requestAddressBookAccessWithCompletion:(ESBasicBlock)completion failure:(ESBasicBlock)failure
{
        if (!ABAddressBookRequestAccessWithCompletion) {
                if (completion)
                        ESDispatchOnMainThreadAsynchrony(completion);
                return;
        }
        
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (kABAuthorizationStatusAuthorized == status) {
                if (completion)
                        ESDispatchOnMainThreadAsynchrony(completion);
                
        } else if (kABAuthorizationStatusNotDetermined == status) {
                ABAddressBookRef addressBook = NULL;
                if (ABAddressBookCreateWithOptions) {
                        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                } else {
                        addressBook = ABAddressBookCreate();
                }
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                        if (addressBook) {
                                CFRelease(addressBook);
                        }
                        if (granted) {
                                if (completion) ESDispatchOnMainThreadAsynchrony(completion);
                        } else {
                                if (failure) ESDispatchOnMainThreadAsynchrony(failure);
                        }
                });
        } else {
                if (failure)
                        ESDispatchOnMainThreadAsynchrony(failure);
        }
}


@end
