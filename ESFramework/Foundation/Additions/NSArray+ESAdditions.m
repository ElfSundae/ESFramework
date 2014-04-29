//
//  NSArray+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-17.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSArray+ESAdditions.h"

@implementation NSArray (ESAdditions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Blocks

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

- (id)match:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return block(obj, idx);
        }];
        if (index == NSNotFound) {
                return nil;
        }
        return self[index];
}

- (NSArray *)matches:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return block(obj, idx);
        }]];
}

- (NSArray *)reject:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        return [self matches:^BOOL(id obj, NSUInteger idx) {
                return !block(obj, idx);
        }];
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableArray

@implementation NSMutableArray (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        NSIndexSet *indexes = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return !block(obj, idx);
        }];
        if (!indexes.count) {
                return;
        }
        [self removeObjectsAtIndexes:indexes];
}

- (void)rejectWith:(BOOL (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        return [self matchWith:^BOOL(id obj, NSUInteger idx) {
                return !block(obj, idx);
        }];
}


@end