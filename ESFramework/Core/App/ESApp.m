//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+Internal.h"

@implementation ESApp

+ (void)load
{
        @autoreleasepool {
                [self isFreshLaunch:nil];
        }
}

+ (instancetype)sharedApp
{
        static id __sharedApp = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                if ([[UIApplication sharedApplication].delegate isKindOfClass:[self class]]) {
                        __sharedApp = [UIApplication sharedApplication].delegate;
                } else {
                        __sharedApp = [[self alloc] init];
                }
        });
        return __sharedApp;
}

- (UIWindow *)window
{
        if (_window) {
                return _window;
        }
        return [[self class] keyWindow];
}

- (UIViewController *)rootViewController
{
        if (_rootViewController) {
                return _rootViewController;
        }
        return [[self class] rootViewController];
}

@end
