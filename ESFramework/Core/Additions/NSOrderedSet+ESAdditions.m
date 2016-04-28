//
//  NSOrderedSet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSOrderedSet+ESAdditions.h"
#import "ESDefines.h"

@implementation NSOrderedSet (ESAdditions)

- (BOOL)isEmpty
{
        return (0 == self.count);
}

- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
        [self enumerateObjectsUsingBlock:block];
}

- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block option:(NSEnumerationOptions)option
{
        [self enumerateObjectsWithOptions:option usingBlock:block];
}

- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx))predicate
{
        return [self indexOfObjectPassingTest:^BOOL(id obj_, NSUInteger idx_, BOOL *stop) {
                if (predicate(obj_, idx_)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        }];
}

- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx))predicate option:(NSEnumerationOptions)option
{
        return [self indexOfObjectWithOptions:option passingTest:^BOOL(id obj_, NSUInteger idx_, BOOL *stop) {
                if (predicate(obj_, idx_)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        }];
}

- (id)matchObject:(BOOL (^)(id obj, NSUInteger idx))predicate
{
        NSParameterAssert(predicate);
        NSUInteger index = [self match:predicate];
        if (NSNotFound != index) {
                return self[index];
        }
        return nil;
}

- (id)matchObject:(BOOL (^)(id obj, NSUInteger idx))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSUInteger index = [self match:predicate option:option];
        if (NSNotFound != index) {
                return self[index];
        }
        return nil;
}

- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
        return [self indexesOfObjectsPassingTest:predicate];
}

- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        return [self indexesOfObjectsWithOptions:option passingTest:predicate];
}

- (NSOrderedSet *)matchesOrderedSets:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
        NSParameterAssert(predicate);
        NSArray *objects = [self objectsAtIndexes:[self matches:predicate]];
        if (ESIsArrayWithItems(objects)) {
                return [NSOrderedSet orderedSetWithArray:objects];
        } else {
                return [NSOrderedSet orderedSet];
        }
}

- (NSOrderedSet *)matchesOrderedSets:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSArray *objects = [self objectsAtIndexes:[self matches:predicate option:option]];
        if (ESIsArrayWithItems(objects)) {
                return [NSOrderedSet orderedSetWithArray:objects];
        } else {
                return [NSOrderedSet orderedSet];
        }
}

@end

@implementation NSMutableOrderedSet (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
        NSParameterAssert(predicate);
        NSIndexSet *set = [self matches:^BOOL(id obj_, NSUInteger idx_, BOOL *stop_) {
                return !predicate(obj_, idx_, stop_);
        }];
        if ([set count]) {
                [self removeObjectsAtIndexes:set];
        }
}

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSIndexSet *set = [self matches:^BOOL(id obj_, NSUInteger idx_, BOOL *stop_) {
                return !predicate(obj_, idx_, stop_);
        } option:option];
        if ([set count]) {
                [self removeObjectsAtIndexes:set];
        }
}

@end