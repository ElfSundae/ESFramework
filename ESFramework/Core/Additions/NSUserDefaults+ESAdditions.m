//
//  NSUserDefaults+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "NSUserDefaults+ESAdditions.h"
#import <NestedObjectSetters/NestedObjectSetters.h>
#import "ESDefines.h"

@implementation NSUserDefaults (ESAdditions)

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath
{
    [self setObject:object forKeyPath:keyPath createIntermediateDictionaries:YES replaceIntermediateObjects:YES];
}

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath createIntermediateDictionaries:(BOOL)createIntermediates replaceIntermediateObjects:(BOOL)replaceIntermediates
{
    [NestedObjectSetters setObject:object onObject:self forKeyPath:keyPath createIntermediateDictionaries:createIntermediates replaceIntermediateObjects:replaceIntermediates];
}

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
}

+ (void)removeObjectForKey:(NSString *)defaultName
{
    [[self standardUserDefaults] removeObjectForKey:defaultName];
    [[self standardUserDefaults] synchronize];
}

+ (void)removeObjectAsynchronyForKey:(NSString *)defaultName
{
    [[self standardUserDefaults] removeObjectForKey:defaultName];
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
    [self replaceRegisteredDefaults:[registered copy]];
}

+ (void)unregisterDefaultsForKeys:(NSArray *)defaultNames
{
    if (!ESIsArrayWithItems(defaultNames)) {
        return;
    }
    NSMutableDictionary *registered = [self registeredDefaults].mutableCopy;
    [registered removeObjectsForKeys:defaultNames];
    [self replaceRegisteredDefaults:[registered copy]];
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
    [self replaceRegisteredDefaults:[registered copy]];
}

+ (void)replaceRegisteredDefaults:(NSDictionary *)registrationDictionary
{
    [[self standardUserDefaults] setVolatileDomain:registrationDictionary forName:NSRegistrationDomain];
}

@end
