//
//  NSUserDefaults+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright © 2015 https://0x123.com. All rights reserved.
//

#import "NSUserDefaults+ESExtension.h"

@implementation NSUserDefaults (ESExtension)

- (NSDictionary<NSString *, id> *)registrationDictionary
{
    return [self volatileDomainForName:NSRegistrationDomain];
}

- (void)setRegistrationDictionary:(NSDictionary<NSString *, id> *)registration
{
    [self setVolatileDomain:[registration copy] forName:NSRegistrationDomain];
}

- (void)setRegistrationObject:(nullable id)value forKey:(NSString *)defaultName
{
    NSMutableDictionary *registration = self.registrationDictionary.mutableCopy;
    [registration setValue:value forKey:defaultName];
    self.registrationDictionary = registration;
}

- (void)removeRegistrationObjectsForKeys:(NSArray<NSString *> *)defaultNames
{
    NSMutableDictionary *registration = self.registrationDictionary.mutableCopy;
    [registration removeObjectsForKeys:defaultNames];
    self.registrationDictionary = registration;
}

@end
