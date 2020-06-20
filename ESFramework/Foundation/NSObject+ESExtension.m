//
//  NSObject+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/11/9.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "NSObject+ESExtension.h"

@implementation NSObject (ESExtension)

- (void)observeNotification:(NSNotificationName)name selector:(SEL)selector
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:selector name:name object:nil];
}

- (void)observeNotification:(nullable NSNotificationName)name object:(nullable id)object selector:(SEL)selector
{
    [NSNotificationCenter.defaultCenter addObserver:self selector:selector name:name object:object];
}

@end
