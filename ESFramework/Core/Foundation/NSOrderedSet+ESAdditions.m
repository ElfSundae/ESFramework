//
//  NSOrderedSet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSOrderedSet+ESAdditions.h"

@implementation NSOrderedSet (ESAdditions)

- (BOOL)isEmpty
{
        return (0 == self.count);
}


- (void)each:(void (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                block(obj, idx);
        }];
}
- (void)eachReversely:(void (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                block(obj, idx);
        }];
}
- (void)eachConcurrently:(void (^)(id obj))block
{
        NSParameterAssert(block);
        [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                block(obj);
        }];
}

- (id)match:(BOOL (^)(id obj))block
{
        NSParameterAssert(block);
        NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return block(obj);
        }];
        if (NSNotFound == index) {
                return nil;
        }
        return self[index];
}

- (NSOrderedSet *)matches:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        NSArray *objects = [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return block(obj, idx);
        }]];
        if (!objects.count) {
                return [[self class] orderedSet];
        }
        return [[self class] orderedSetWithArray:objects];
}

- (NSOrderedSet *)reject:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        return [self matches:^BOOL(id obj, NSUInteger idx) {
                return !block(obj, idx);
        }];
}

@end

@implementation NSMutableOrderedSet (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        NSIndexSet *set = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return !block(obj, idx);
        }];
        if (!set.count) {
                return;
        }
        [self removeObjectsAtIndexes:set];
}

- (void)rejectWith:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        [self matches:^BOOL(id obj, NSUInteger idx) {
                return !block(obj, idx);
        }];
}

@end