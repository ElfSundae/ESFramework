//
//  NSUserDefaults+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "NSUserDefaults+ESAdditions.h"

@implementation NSUserDefaults (ESAdditions)

- (NSDictionary<NSString *, id> *)registeredDefaults
{
    return [self volatileDomainForName:NSRegistrationDomain];
}

- (void)setRegisteredDefaults:(NSDictionary<NSString *, id> *)registeredDefaults
{
    [self setVolatileDomain:registeredDefaults.copy forName:NSRegistrationDomain];
}

- (void)setRegisteredObject:(nullable id)value forKey:(NSString *)defaultName
{
    NSMutableDictionary *registered = self.registeredDefaults.mutableCopy;
    [registered setValue:value forKey:defaultName];
    self.registeredDefaults = registered;
}

- (void)removeRegisteredObjectsForKeys:(NSArray<NSString *> *)defaultNames
{
    NSMutableDictionary *registered = self.registeredDefaults.mutableCopy;
    [registered removeObjectsForKeys:defaultNames];
    self.registeredDefaults = registered;
}

@end
