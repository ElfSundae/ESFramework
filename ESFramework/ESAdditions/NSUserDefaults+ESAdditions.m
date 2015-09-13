//
//  NSUserDefaults+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "NSUserDefaults+ESAdditions.h"
#import "ESDefines.h"

@implementation NSUserDefaults (ESAdditions)

+ (id)objectForKey:(NSString *)defaultName
{
        return [[self standardUserDefaults] objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
        [[self standardUserDefaults] setObject:value forKey:defaultName];
        [[self standardUserDefaults] synchronize];
}

+ (void)setObjectAsynchrony:(id)value forKey:(NSString *)defaultName
{
        [[self standardUserDefaults] setObject:value forKey:defaultName];
        ESDispatchOnDefaultQueue(^{
                [[self standardUserDefaults] synchronize];
        });
}

+ (void)removeObjectForKey:(NSString *)defaultName
{
        [[self standardUserDefaults] removeObjectForKey:defaultName];
        [[self standardUserDefaults] synchronize];
}

+ (void)removeObjectAsynchronyForKey:(NSString *)defaultName
{
        [[self standardUserDefaults] removeObjectForKey:defaultName];
        ESDispatchOnDefaultQueue(^{
                [[self standardUserDefaults] synchronize];
        });
}

+ (NSDictionary *)registeredDefaults;
{
        return [[self standardUserDefaults] volatileDomainForName:NSRegistrationDomain];
}

+ (void)registerDefaults:(NSDictionary *)registrationDictionary
{
        [[self standardUserDefaults] registerDefaults:registrationDictionary];
}

+ (void)unregisterDefaultsForKey:(NSString *)defaultName
{
        if (!defaultName) {
                return;
        }
        NSMutableDictionary *registered = [self registeredDefaults].mutableCopy;
        [registered removeObjectForKey:defaultName];
        [self replaceRegisteredDefaults:registered];
}

+ (void)unregisterDefaultsForKeys:(NSArray *)defaultNames
{
        if (!ESIsArrayWithItems(defaultNames)) {
                return;
        }
        NSMutableDictionary *registered = [self registeredDefaults].mutableCopy;
        [registered removeObjectsForKeys:defaultNames];
        [self replaceRegisteredDefaults:registered];
}

+ (void)replaceRegisteredObject:(id)value forKey:(NSString *)defaultName
{
        if (!defaultName) {
                return;
        }
        NSMutableDictionary *registered = [self registeredDefaults].mutableCopy;
        if (value) {
                [registered setObject:value forKey:defaultName];
        } else {
                [registered removeObjectForKey:defaultName];
        }
        [self replaceRegisteredDefaults:registered];
}

+ (void)replaceRegisteredDefaults:(NSDictionary *)registrationDictionary
{
        [[self standardUserDefaults] setVolatileDomain:registrationDictionary forName:NSRegistrationDomain];
}

@end
