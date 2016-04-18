//
//  ESApp.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+Private.h"

@implementation ESApp

+ (void)load
{
        [self isFreshLaunch:NULL];
}

+ (instancetype)sharedApp
{
        return _ESSharedApp();
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
        if (self == application.delegate) {
                self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                self.window.backgroundColor = [UIColor whiteColor];
        }
        return YES;
}

@end