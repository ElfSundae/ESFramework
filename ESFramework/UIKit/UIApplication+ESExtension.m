//
//  UIApplication+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/05.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "UIApplication+ESExtension.h"
#if TARGET_OS_IOS || TARGET_OS_TV

#import <objc/runtime.h>
#import "ESHelpers.h"
#import "UIDevice+ESExtension.h"
#import "UIWindow+ESExtension.h"

static const void *registerForRemoteNotificationsSucceededKey = &registerForRemoteNotificationsSucceededKey;
static const void *registerForRemoteNotificationsFailedKey = &registerForRemoteNotificationsFailedKey;

static IMP es_originalIMP_application_didRegisterForRemoteNotificationsWithDeviceToken = NULL;
static IMP es_originalIMP_application_didFailToRegisterForRemoteNotificationsWithError = NULL;

static void es_application_registerForRemoteNotifications_callback(id self, SEL _cmd, UIApplication *application, id object)
{
    IMP originalIMP = NULL;
    void (^block)(id) = nil;

    if ([object isKindOfClass:[NSData class]]) {
        UIDevice.currentDevice.deviceToken = (NSData *)object;

        originalIMP = es_originalIMP_application_didRegisterForRemoteNotificationsWithDeviceToken;
        block = objc_getAssociatedObject(application, registerForRemoteNotificationsSucceededKey);
    } else if ([object isKindOfClass:[NSError class]]) {
        originalIMP = es_originalIMP_application_didFailToRegisterForRemoteNotificationsWithError;
        block = objc_getAssociatedObject(application, registerForRemoteNotificationsFailedKey);
    }

    if (originalIMP) {
        ((void (*)(id, SEL, id, id))originalIMP)(self, _cmd, application, object);
    }

    if (block) {
        block(object);
    }

    objc_setAssociatedObject(application, registerForRemoteNotificationsSucceededKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(application, registerForRemoteNotificationsFailedKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@implementation UIApplication (ESExtension)

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
        es_originalIMP_application_didRegisterForRemoteNotificationsWithDeviceToken =
            class_replaceMethod([delegate class], @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), (IMP)es_application_registerForRemoteNotifications_callback, "v@:@@");

        es_originalIMP_application_didFailToRegisterForRemoteNotificationsWithError =
            class_replaceMethod([delegate class], @selector(application:didFailToRegisterForRemoteNotificationsWithError:), (IMP)es_application_registerForRemoteNotifications_callback, "v@:@@");
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

- (void)registerForRemoteNotificationsWithSuccess:(nullable void (^)(NSData *deviceToken))success
                                          failure:(nullable void (^)(NSError *error))failure
{
    objc_setAssociatedObject(self, registerForRemoteNotificationsSucceededKey, success, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, registerForRemoteNotificationsFailedKey, failure, OBJC_ASSOCIATION_COPY_NONATOMIC);

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
    if (@available(iOS 10, tvOS 10, *)) {
        [self openURL:telURL options:@{} completionHandler:nil];
    } else {
        [self openURL:telURL];
    }
}

@end

#endif
