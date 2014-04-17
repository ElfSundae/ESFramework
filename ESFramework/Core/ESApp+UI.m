//
//  ESApp+UI.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

@implementation ESApp (UI)

+ (UIViewController *)rootViewController
{
        UIViewController *rootViewController = nil;
        id appDelegate = [UIApplication sharedApplication].delegate;
        if ([appDelegate respondsToSelector:@selector(window)]) {
                rootViewController = [(UIWindow *)[appDelegate valueForKey:@"window"] rootViewController];
                if (!rootViewController) {
                        rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                }
        }
        
        if (![rootViewController isKindOfClass:[UIViewController class]]) {
                return nil;
        }

        return rootViewController;
}

+ (UIViewController *)rootViewControllerForPresenting
{
        UIViewController *rootViewController = [self rootViewController];
        
        if ([rootViewController respondsToSelector:@selector(presentedViewController)]) {
                while ([rootViewController.presentedViewController isKindOfClass:[UIViewController class]]) {
                        rootViewController = rootViewController.presentedViewController;
                }
        }
        
        return rootViewController;
}

+ (void)dismissAllViewControllersAnimated: (BOOL)flag completion: (void (^)(void))completion
{
        UIViewController *root = [self rootViewController];
        if (root) {
                [root dismissViewControllerAnimated:flag completion:completion];
        }
}
@end
