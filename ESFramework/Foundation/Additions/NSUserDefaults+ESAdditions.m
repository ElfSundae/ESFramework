//
//  NSUserDefaults+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSUserDefaults+ESAdditions.h"
#import <ESFrameworkCore/ESDefines.h>

@implementation NSUserDefaults (ESAdditions)

+ (id)objectForKey:(NSString *)key
{
        return [[self standardUserDefaults] objectForKey:key];
}

+ (void)setObject:(id)object forKey:(NSString *)key
{
        NSUserDefaults *ud = [self standardUserDefaults];
        ESDispatchAsyncOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, ^{
                [ud setObject:object forKey:key];
                [ud synchronize];
        });
}

+ (void)removeObjectForKey:(NSString *)key
{
        NSUserDefaults *ud = [self standardUserDefaults];
        ESDispatchAsyncOnGlobalQueue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, ^{
                [ud removeObjectForKey:key];
                [ud synchronize];
        });
}

@end
