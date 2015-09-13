//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"
#import "ESApp+Private.h"
#import "NSString+ESAdditions.h"

NSString *const ESAppErrorDomain = @"ESAppErrorDomain";

@implementation ESApp

+ (void)load
{
        @autoreleasepool {
                [self isFreshLaunch:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_es_applicationDidBecomeActiveNotificationHandler:) name:UIApplicationDidBecomeActiveNotification object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_es_applicationDidFinishLaunchingNotificationHandler:) name:UIApplicationDidFinishLaunchingNotification object:nil];
        }
}

+ (instancetype)sharedApp
{
        static id __gSharedApp = nil;
        
        id appDelegate = [UIApplication sharedApplication].delegate;
        if ([appDelegate isKindOfClass:[self class]]) {
                if (__gSharedApp) {
                        __gSharedApp = nil;
                }
                return appDelegate;
        }
        
        if (!__gSharedApp) {
                __gSharedApp = [[super alloc] init];
        }
        return __gSharedApp;
}

- (UIWindow *)window
{
        return _window ?: [[self class] keyWindow];
}

- (UIViewController *)rootViewController
{
        return _rootViewController ?: [[self class] rootViewController];
}

@end