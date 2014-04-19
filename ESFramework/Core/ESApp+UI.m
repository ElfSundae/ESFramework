//
//  ESApp+UI.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@implementation ESApp (UI)

+ (UIWindow *)keyWindow
{
        static UIWindow *__gKeyWindow = nil;
        if (!__gKeyWindow) {
                id delegate = [UIApplication sharedApplication].delegate;
                if ([delegate respondsToSelector:@selector(window)]) {
                        __gKeyWindow = (UIWindow *)[delegate valueForKey:@"window"];
                }
        }
        
        if (__gKeyWindow) {
                return __gKeyWindow;
        }
        
        return [UIApplication sharedApplication].keyWindow;
        
}

+ (UIViewController *)rootViewController
{
        UIViewController *rootViewController = [self keyWindow].rootViewController;
        if ([rootViewController isKindOfClass:[UIViewController class]]) {
                return rootViewController;
        }
        return nil;
}

+ (UIViewController *)rootViewControllerForPresenting
{
        UIViewController *rootViewController = [self rootViewController];
        
        while ([rootViewController.presentedViewController isKindOfClass:[UIViewController class]]) {
                rootViewController = rootViewController.presentedViewController;
        }
        
        return rootViewController;
}

+ (void)dismissAllViewControllersAnimated: (BOOL)flag completion: (void (^)(void))completion
{
        [[self rootViewController] dismissViewControllerAnimated:flag completion:completion];
}

@end
