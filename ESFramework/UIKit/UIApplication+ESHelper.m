//
//  UIApplication+ESHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/15.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIApplication+ESAdditions.h"
#import <objc/runtime.h>
#import "ESMacros.h"

NSString *const ESMultitaskingBackgroundTaskName = @"ESMultitaskingBackgroundTask";

ESDefineAssociatedObjectKey(multitaskingBackgroundTaskIdentifier)

@implementation UIApplication (ESHelper)

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

- (UIBackgroundTaskIdentifier)multitaskingBackgroundTaskIdentifier
{
    NSNumber *value = objc_getAssociatedObject(self, multitaskingBackgroundTaskIdentifierKey);
    return value ? [value unsignedIntegerValue] : UIBackgroundTaskInvalid;
}

- (void)setMultitaskingBackgroundTaskIdentifier:(UIBackgroundTaskIdentifier)identifier
{
    objc_setAssociatedObject(self, multitaskingBackgroundTaskIdentifierKey,
                             @(identifier), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isMultitaskingEnabled
{
    return self.multitaskingBackgroundTaskIdentifier != UIBackgroundTaskInvalid;
}

- (void)enableMultitasking
{
    if (self.isMultitaskingEnabled) {
        return;
    }

    self.multitaskingBackgroundTaskIdentifier =
        [self beginBackgroundTaskWithName:ESMultitaskingBackgroundTaskName expirationHandler:^{
            [self disableMultitasking];
            [self enableMultitasking];
        }];
}

- (void)disableMultitasking
{
    if (self.isMultitaskingEnabled) {
        [self endBackgroundTask:self.multitaskingBackgroundTaskIdentifier];
        self.multitaskingBackgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
}

@end
