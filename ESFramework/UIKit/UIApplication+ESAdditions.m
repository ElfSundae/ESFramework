//
//  UIApplication+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIApplication+ESAdditions.h"
#import "ESMacros.h"
#import "ESHelper.h"
#import "UIDevice+ESAdditions.h"
#import "UIWindow+ESAdditions.h"

ESDefineAssociatedObjectKey(registerRemoteNotificationsCompletion);

typedef void (*_ESFunctionWithTwoObjectArgs)(id, SEL, id, id);

static IMP es_original_application_didRegisterForRemoteNotificationsWithDeviceToken = NULL;
static IMP es_original_application_didFailToRegisterForRemoteNotificationsWithError = NULL;

static void es_application_didRegisterForRemoteNotificationsWithDeviceToken(id self, SEL _cmd, UIApplication *application, NSData *deviceToken)
{
    UIDevice.currentDevice.deviceToken = deviceToken;

    if (es_original_application_didRegisterForRemoteNotificationsWithDeviceToken) {
        ((_ESFunctionWithTwoObjectArgs)es_original_application_didRegisterForRemoteNotificationsWithDeviceToken)(self, _cmd, application, deviceToken);
    }

    if (application.registerRemoteNotificationsCompletion) {
        application.registerRemoteNotificationsCompletion(deviceToken, nil);
        application.registerRemoteNotificationsCompletion = nil;
    }
}

static void es_application_didFailToRegisterForRemoteNotificationsWithError(id self, SEL _cmd, UIApplication *application, NSError *error)
{
    if (es_original_application_didFailToRegisterForRemoteNotificationsWithError) {
        ((_ESFunctionWithTwoObjectArgs)es_original_application_didFailToRegisterForRemoteNotificationsWithError)(self, _cmd, application, error);
    }

    if (application.registerRemoteNotificationsCompletion) {
        application.registerRemoteNotificationsCompletion(nil, error);
        application.registerRemoteNotificationsCompletion = nil;
    }
}

@implementation UIApplication (ESAdditions)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ESSwizzleInstanceMethod(self, @selector(setDelegate:), @selector(es_setDelegate:));
    });
}

- (void)es_setDelegate:(id<UIApplicationDelegate>)delegate
{
    [self es_setDelegate:delegate];

    if (delegate) {
        es_original_application_didRegisterForRemoteNotificationsWithDeviceToken =
            class_replaceMethod([delegate class], @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), (IMP)es_application_didRegisterForRemoteNotificationsWithDeviceToken, "v@:@@");

        es_original_application_didFailToRegisterForRemoteNotificationsWithError =
            class_replaceMethod([delegate class], @selector(application:didFailToRegisterForRemoteNotificationsWithError:), (IMP)es_application_didFailToRegisterForRemoteNotificationsWithError, "v@:@@");
    }
}

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

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self.topmostViewController presentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (void)dismissViewControllersAnimated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    [self.rootViewController dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissKeyboard
{
    [self sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void (^)(NSData * _Nullable, NSError * _Nullable))registerRemoteNotificationsCompletion
{
    return objc_getAssociatedObject(self, registerRemoteNotificationsCompletionKey);
}

- (void)setRegisterRemoteNotificationsCompletion:(void (^)(NSData * _Nullable, NSError * _Nullable))completion
{
    objc_setAssociatedObject(self, registerRemoteNotificationsCompletionKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)registerForRemoteNotificationsWithCompletion:(void (^ _Nullable)(NSData * _Nullable deviceToken, NSError * _Nullable error))completion
{
    self.registerRemoteNotificationsCompletion = completion;

    [self registerForRemoteNotifications];
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
