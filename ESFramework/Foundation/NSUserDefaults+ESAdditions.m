//
//  NSUserDefaults+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "NSUserDefaults+ESAdditions.h"
#import <NestedObjectSetters/NestedObjectSetters.h>

@implementation NSUserDefaults (ESAdditions)

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath
{
    [self setObject:object forKeyPath:keyPath createIntermediateDictionaries:YES replaceIntermediateObjects:YES];
}

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath createIntermediateDictionaries:(BOOL)createIntermediates replaceIntermediateObjects:(BOOL)replaceIntermediates
{
    [NestedObjectSetters setObject:object onObject:self forKeyPath:keyPath createIntermediateDictionaries:createIntermediates replaceIntermediateObjects:replaceIntermediates];
}

- (NSDictionary<NSString *, id> *)registeredDefaults
{
    return [self volatileDomainForName:NSRegistrationDomain];
}

- (void)replaceRegisteredDefaultsWith:(NSDictionary<NSString *, id> *)registration
{
    [self setVolatileDomain:registration forName:NSRegistrationDomain];
}

- (void)setRegisteredObject:(id)value forKey:(NSString *)defaultName
{
    NSMutableDictionary *registered = self.registeredDefaults.mutableCopy;
    [registered setValue:value forKey:defaultName];
    [self replaceRegisteredDefaultsWith:registered.copy];
}

- (void)unregisterDefaultsForKeys:(NSArray<NSString *> *)defaultNames
{
    NSMutableDictionary *registered = self.registeredDefaults.mutableCopy;
    [registered removeObjectsForKeys:defaultNames];
    [self replaceRegisteredDefaultsWith:registered.copy];
}

@end
