//
//  NSArray+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-17.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
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

- (void)each_reversely:(void (^)(id obj, NSUInteger idx))block
{
        NSParameterAssert(block);
        [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                block(obj, idx);
        }];
}

- (void)each_concurrently:(void (^)(id obj))block
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
