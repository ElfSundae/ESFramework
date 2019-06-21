//
//  NSMapTable+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/06/05.
//  Copyright © 2019 https://0x123.com All rights reserved.
//

#import "NSMapTable+ESExtension.h"

@implementation NSMapTable (ESExtension)

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id)key
{
    if (object) {
        [self setObject:object forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}

- (NSArray *)allKeys
{
    return self.keyEnumerator.allObjects;
}

- (NSArray *)allValues
{
    return self.objectEnumerator.allObjects ?: @[];
}

- (void)enumerateKeysAndObjectsUsingBlock:(void (NS_NOESCAPE ^)(id key, id obj, BOOL *stop))block
{
    BOOL stop = NO;
    for (id key in self) {
        block(key, [self objectForKey:key], &stop);

        if (stop) {
            return;
        }
    }
}

@end
