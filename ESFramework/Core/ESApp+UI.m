//
//  ESApp+UI.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp+ESInternal.h"

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
        
        if (!__gKeyWindow) {
                // maybe the #keyWindow is just a temporary keyWindow,
                // so we do not save it to the #__gKeyWindow.
                return [UIApplication sharedApplication].keyWindow;
        }
        return __gKeyWindow;
}

- (UIWindow *)keyWindow
{
        return [[self class] keyWindow];
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

- (void)clearApplicationIconBadgeNumber
{
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
