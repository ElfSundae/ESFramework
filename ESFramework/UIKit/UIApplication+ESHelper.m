//
//  UIApplication+ESHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/15.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "UIApplication+ESAdditions.h"

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

@end
