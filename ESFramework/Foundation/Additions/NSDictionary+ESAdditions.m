//
//  NSDictionary+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDictionary+ESAdditions.h"

@implementation NSDictionary (ESAdditions)

- (id)smartObjectForKey:(id)key
{
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSNull class]]) {
                object = nil;
        }
        return object;
}

- (void)each:(void (^)(id key, id obj))block
{
        NSParameterAssert(block);
        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                block(key, obj);
        }];
}

- (void)eachReversely:(void (^)(id key, id obj))block
{
        NSParameterAssert(block);
        [self enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(id key, id obj, BOOL *stop) {
                block(key, obj);
        }];
}

- (void)eachConcurrently:(void (^)(id key, id obj))block
{
        NSParameterAssert(block);
        [self enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, id obj, BOOL *stop) {
                block(key, obj);
        }];
}

- (id)match:(BOOL (^)(id key, id obj))block
{
        NSParameterAssert(block);
        NSSet *set = [self keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                if (block(key, obj)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        }];
        return [set anyObject];
}

- (NSDictionary *)matches:(BOOL (^)(id key, id obj))block
{
        NSParameterAssert(block);
        NSSet *set = [self keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                return block(key, obj);
        }];
        NSArray *keys = [set allObjects];
        NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
        return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)reject:(BOOL (^)(id key, id obj))block
{
        NSParameterAssert(block);
        return [self matches:^BOOL(id key, id obj) {
                return !block(key, obj);
        }];
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (ESAdditions)

- (void)matchWith:(BOOL (^)(id key, id obj))block
{
        NSParameterAssert(block);
        NSArray *keys = [[self keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
                return !block(key, obj);
        }] allObjects];
        [self removeObjectsForKeys:keys];
}

- (void)rejectWith:(BOOL (^)(id key, id obj))block
{
        NSParameterAssert(block);
        [self matchWith:^BOOL(id key, id obj) {
                return !block(key, obj);
        }];
}

@end

