//
//  UIApplication+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "UIApplication+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import "UIWindow+ESExtension.h"

@implementation UIApplication (ESExtension)

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

- (UIViewController *)topmostViewController
{
    return self.delegate.window.topmostViewController;
}

- (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self.topmostViewController presentViewController:viewController animated:animated completion:completion];
}

- (void)dismissAllViewControllersAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self.rootViewController dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissKeyboard
{
    [self sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)simulateMemoryWarning
{
    SEL memoryWarningSel = NSSelectorFromString(@"_performMemoryWarning");
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
    if (@available(iOS 10, tvOS 10, *)) {
        [self openURL:telURL options:@{} completionHandler:nil];
    } else {
        [self openURL:telURL];
    }
}

@end

#endif
