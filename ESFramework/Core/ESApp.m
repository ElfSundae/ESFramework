//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+ESInternal.h"

@implementation ESApp

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

static id __gSharedApp = nil;
ES_SINGLETON_IMP(sharedApp);
//+ (instancetype)sharedApp
//{
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//                        __gSharedApp = [[super alloc] init];
//        });
//        return __gSharedApp;
//}

+ (void)load {
        @autoreleasepool {
                [self sharedApp];       
        }
}

- (id)init
{
        self = [super init];
        if (self) {
                [[self class] isFreshLaunch:nil];
                [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : [[self class] userAgent]}];
                
                ES_WEAK_VAR(self, _weakSelf);
                [self addNotification:UIApplicationDidFinishLaunchingNotification handler:^(NSNotification *notification, NSDictionary *userInfo) {
                        ES_STRONG_VAR_CHECK_NULL(_weakSelf, _self);
                        
                        if ([[_self class] _isUIApplicationDelegate]) {
                                __gSharedApp = [UIApplication sharedApplication].delegate;
                        }
                        
                        [[_self class] enableMultitasking];
                        
                        
                        if (![[_self class] _isUIApplicationDelegate]) {
                                _self.remoteNotification = userInfo[UIApplicationLaunchOptionsRemoteNotificationKey];
                        }
                        if (_self.remoteNotification) {
                                [_self applicationDidReceiveRemoteNotification:_self.remoteNotification];
                        }
                }];
        }
        return self;
}

- (UIApplication *)application
{
        return [UIApplication sharedApplication];
}

- (UIViewController *)rootViewController
{
        if (!_rootViewController) {
                if ([[self class] _isUIApplicationDelegate]) {
                        [self setupRootViewController];
                } else {
                        return self.keyWindow.rootViewController;
                }
        }
        return _rootViewController;
}

@end
