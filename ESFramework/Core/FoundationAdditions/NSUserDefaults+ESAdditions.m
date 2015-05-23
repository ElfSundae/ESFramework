//
//  NSUserDefaults+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "NSUserDefaults+ESAdditions.h"
#import "ESDefines.h"

ES_CATEGORY_FIX(NSUserDefaults_ESAdditions)

@implementation NSUserDefaults (ESAdditions)

+ (id)objectForKey:(NSString *)key
{
        return [[self standardUserDefaults] objectForKey:key];
}

+ (void)setObject:(id)object forKey:(NSString *)key
{
        NSUserDefaults *ud = [self standardUserDefaults];
        [ud setObject:object forKey:key];
        [ud synchronize];
}

+ (void)setObjectAsynchrony:(id)object forKey:(NSString *)key
{
        ESDispatchOnDefaultQueue(^{
                [self setObject:object forKey:key];
        });
}

+ (void)removeObjectForKey:(NSString *)key
{
        NSUserDefaults *ud = [self standardUserDefaults];
        [ud removeObjectForKey:key];
        [ud synchronize];
}

+ (void)removeObjectAsynchronyForKey:(NSString *)key
{
        ESDispatchOnDefaultQueue(^{
                [self removeObjectForKey:key];
        });
}

@end
