//
//  ESApp+Helper.m
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"
#import "ESValue.h"
#import "NSUserDefaults+ESAdditions.h"

static UIBackgroundTaskIdentifier __esBackgroundTaskIdentifier = 0;

@implementation ESApp (_Helper)

+ (BOOL)isFreshLaunch:(NSString *__autoreleasing *)previousAppVersion
{
#define ESAppCheckFreshLaunchUserDefaultsKey @"ESAppCheckFreshLaunch"
        static NSString *__gPreviousVersion = nil;
        static BOOL __gIsFreshLaunch = NO;
        
        static dispatch_once_t onceTokenCheckAppFreshLaunch;
        dispatch_once(&onceTokenCheckAppFreshLaunch, ^{
                __gPreviousVersion = ESStringValue([NSUserDefaults objectForKey:ESAppCheckFreshLaunchUserDefaultsKey]);
                ESIsStringWithAnyText(__gPreviousVersion) || (__gPreviousVersion = nil);
                NSString *currentVersion = [ESApp appVersion];
                
                if (__gPreviousVersion && [__gPreviousVersion isEqualToString:currentVersion]) {
                        __gIsFreshLaunch = NO;
                } else {
                        __gIsFreshLaunch = YES;
                        [NSUserDefaults setObjectAsynchrony:currentVersion forKey:ESAppCheckFreshLaunchUserDefaultsKey];
                }
        });
        
        if (previousAppVersion) {
                *previousAppVersion = [__gPreviousVersion copy];
        }
        return __gIsFreshLaunch;
}

+ (void)deleteHTTPCookiesForURL:(NSURL *)URL
{
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies = [cookieStorage cookiesForURL:URL];
        for (NSHTTPCookie *c in cookies) {
                [cookieStorage deleteCookie:c];
        }
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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [[UIApplication sharedApplication] performSelector:memoryWarningSel];
#pragma clang diagnostic pop
        } else {
                printf("UIApplication no longer responds \"_performMemoryWarning\" selector.\n");
                exit(1);
        }
}

+ (void)enableMultitasking
{
        ESDispatchOnMainThreadSynchrony(^{
                if (![self isMultitaskingEnabled]) {
                     __esBackgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                             ESDispatchOnMainThreadAsynchrony(^{
                                     [self disableMultitasking];
                                     [self enableMultitasking];
                             });
                     }];
                }
                
        });
}

+ (void)disableMultitasking
{
        ESDispatchOnMainThreadSynchrony(^{
                if ([self isMultitaskingEnabled]) {
                        [[UIApplication sharedApplication] endBackgroundTask:[self backgroundTaskIdentifier]];
                        __esBackgroundTaskIdentifier = UIBackgroundTaskInvalid;
                }
        });
}

+ (BOOL)isMultitaskingEnabled
{
        return ([self backgroundTaskIdentifier] && [self backgroundTaskIdentifier] != UIBackgroundTaskInvalid);
}

+ (UIBackgroundTaskIdentifier)backgroundTaskIdentifier
{
        return __esBackgroundTaskIdentifier;
}

+ (NSDictionary *)loadPreferencesDefaultsFromSettingsPlistAtURL:(NSURL *)plistURL;
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        
        if ([plistURL isKindOfClass:[NSURL class]]) {
                NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfURL:plistURL];
                if ([settingsDict isKindOfClass:[NSDictionary class]]) {
                        NSArray *prefSpecifierArray = settingsDict[@"PreferenceSpecifiers"];
                        if (ESIsArrayWithItems(prefSpecifierArray)) {
                                
                                for (NSDictionary *prefItem in prefSpecifierArray) {
                                        if (![prefItem isKindOfClass:[NSDictionary class]]) {
                                                continue;
                                        }
                                        
                                        // What kind of control is used to represent the preference element in the Settings app.
                                        NSString *itemType = prefItem[@"Type"];
                                        // How this preference element maps to the defaults database for the app.
                                        NSString *itemKey = prefItem[@"Key"];
                                        // The default value for the preference key.
                                        NSString *itemDefaultValue = prefItem[@"DefaultValue"];
                                        
                                        // If this is a 'Child Pane Element'.  That is, a reference to another page.
                                        if ([itemType isEqualToString:@"PSChildPaneSpecifier"]) {
                                                
                                                // There must be a value associated with the 'File' key in this preference
                                                // element's dictionary.  Its value is the name of the plist file in the
                                                // Settings bundle for the referenced page.
                                                NSString *itemFile = prefItem[@"File"];
                                                
                                                // Recurs on the referenced page.
                                                NSURL *childPlistURL = [[plistURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:itemFile];
                                                NSDictionary *childPageKeyValuePairs = [self loadPreferencesDefaultsFromSettingsPlistAtURL:childPlistURL];
                                                
                                                // Add the child results to our dictionary
                                                [result addEntriesFromDictionary:childPageKeyValuePairs];
                                                
                                        } else {
                                                // Some elements, such as 'Group' or 'Text Field' elements do not contain
                                                // a key and default value.  Skip those.
                                                if (ESIsStringWithAnyText(itemKey) && itemDefaultValue) {
                                                        result[itemKey] = itemDefaultValue;
                                                }
                                        }
                                }
                        }
                }
        }
        
        return [result copy];
}


+ (BOOL)registerPreferencesDefaultsWithDefaultValues:(NSDictionary *)defaultValues forRootSettingsPlistAtURL:(NSURL *)rootPlistURL
{
        NSMutableDictionary *values = [NSMutableDictionary dictionary];
        NSDictionary *loadValues = [self loadPreferencesDefaultsFromSettingsPlistAtURL:rootPlistURL];
        if (ESIsDictionaryWithItems(loadValues)) {
                [values addEntriesFromDictionary:loadValues];
        }
        if (ESIsDictionaryWithItems(defaultValues)) {
                [values addEntriesFromDictionary:defaultValues];
        }
        
        if (values.count) {
                [[NSUserDefaults standardUserDefaults] registerDefaults:values];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return YES;
        }
        
        return NO;
}

+ (BOOL)registerPreferencesDefaultsWithDefaultValuesForAppDefaultRootSettingsPlist:(NSDictionary *)defaultValues
{
        NSURL *defaultRootSettings = [[[NSBundle mainBundle] URLForResource:@"Settings" withExtension:@"bundle"]
                                      URLByAppendingPathComponent:@"Root.plist"];
        return [self registerPreferencesDefaultsWithDefaultValues:defaultValues
                                        forRootSettingsPlistAtURL:defaultRootSettings];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UI

+ (UIWindow *)keyWindow
{
        id appDelegate = [UIApplication sharedApplication].delegate;
        if ([appDelegate respondsToSelector:@selector(window)]) {
                id window = [appDelegate valueForKey:@"window"];
                if ([window isKindOfClass:[UIWindow class]]) {
                        return window;
                }
        }
        return [UIApplication sharedApplication].keyWindow;
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
        
        while (rootViewController.presentedViewController) {
                rootViewController = rootViewController.presentedViewController;
        }
        
        return rootViewController;
}

+ (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion
{
        [[self rootViewControllerForPresenting] presentViewController:viewControllerToPresent animated:animated completion:completion];
}

+ (void)dismissAllViewControllersAnimated:(BOOL)animated completion:(void (^)(void))completion
{
        [[self rootViewController] dismissViewControllerAnimated:animated completion:completion];
}

+ (BOOL)isInForeground
{
        return ([UIApplication sharedApplication].applicationState == UIApplicationStateActive);
}

+ (void)clearApplicationIconBadgeNumber
{
        if ([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - OpenURL

+ (BOOL)canOpenPhoneCall
{
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:"]];
}

+ (BOOL)openPhoneCall:(NSString *)phoneNumber returnToAppAfterCall:(BOOL)shouldReturn
{
        phoneNumber = ESStringValue(phoneNumber);
        if (phoneNumber) {
                NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
                if ([self canOpenPhoneCall]) {
                        if (shouldReturn) {
                                UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
                                [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
                                return YES;
                        } else {
                                return [[UIApplication sharedApplication] openURL:telURL];
                        }
                }
        }
        return NO;
}

@end
