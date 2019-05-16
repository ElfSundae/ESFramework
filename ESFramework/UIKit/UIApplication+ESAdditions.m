//
//  UIApplication+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIApplication+ESAdditions.h"

@implementation UIApplication (ESAdditions)

- (UIWindow *)appWindow
{
    return self.delegate.window;
}

- (void)setAppWindow:(UIWindow *)appWindow
{
    self.delegate.window = appWindow;
}

- (UIViewController *)rootViewController
{
    return self.delegate.window.rootViewController;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    self.delegate.window.rootViewController = rootViewController;
}

- (UIViewController *)rootViewControllerForPresenting
{
    UIViewController *viewController = self.rootViewController;

    while (viewController.presentedViewController) {
        viewController = viewController.presentedViewController;
    }

    return viewController;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self.rootViewControllerForPresenting presentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (void)dismissViewControllersAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self.rootViewController dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissKeyboard
{
    [self sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)simulateMemoryWarning
{
    SEL memoryWarningSel =  NSSelectorFromString(@"_performMemoryWarning");
    if ([self respondsToSelector:memoryWarningSel]) {
        printf("=== Simulate Memory Warning! ===\n");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:memoryWarningSel];
#pragma clang diagnostic pop
    } else {
        printf("UIApplication no longer responds \"_performMemoryWarning\" selector.\n");
        exit(1);
    }
}

- (BOOL)canMakePhoneCalls
{
    return [self canOpenURL:[NSURL URLWithString:@"tel:"]];
}

- (void)makePhoneCall:(NSString *)phoneNumber
{
    NSURL *telURL = [NSURL URLWithString:[@"tel:" stringByAppendingString:phoneNumber]];
    if (@available(iOS 10.0, *)) {
        [self openURL:telURL options:@{} completionHandler:nil];
    } else {
        [self openURL:telURL];
    }
}

@end
