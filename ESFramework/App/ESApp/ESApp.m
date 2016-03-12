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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        /* Setup window */
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.];
        
        return YES;
}

@end