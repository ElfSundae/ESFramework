//
//  NSArray+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-17.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSArray+ESAdditions.h"
#import "ESDefines.h"

@implementation NSArray (ESAdditions)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Blocks

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
        NSParameterAssert(predicate);
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
        NSParameterAssert(predicate);
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

- (NSArray *)matchesObjects:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
        NSParameterAssert(predicate);
        NSIndexSet *indexes = [self matches:predicate];
        if ([indexes count]) {
                return [self objectsAtIndexes:indexes];
        }
        return [NSArray array];
}

- (NSArray *)matchesObjects:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSIndexSet *indexes = [self matches:predicate option:option];
        if ([indexes count]) {
                return [self objectsAtIndexes:indexes];
        }
        return [NSArray array];
}

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile completion:(void (^)(BOOL result))completion
{
        ESDispatchOnDefaultQueue(^{
                BOOL result = (ESTouchDirectoryAtFilePath(path) &&
                               [self writeToFile:path atomically:useAuxiliaryFile]);
                ESDispatchOnMainThreadAsynchrony(^{
                        if (completion) completion(result);
                });
        });
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableArray

@implementation NSMutableArray (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
        NSParameterAssert(predicate);
        NSIndexSet *indexes = [self matches:^BOOL(id obj_, NSUInteger idx_, BOOL *stop_) {
                return !predicate(obj_, idx_, stop_);
        }];
        if (indexes.count) {
                [self removeObjectsAtIndexes:indexes];
        }
}

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSIndexSet *indexes = [self matches:^BOOL(id obj_, NSUInteger idx_, BOOL *stop_) {
                return !predicate(obj_, idx_, stop_);
        } option:option];
        
        if (indexes.count) {
                [self removeObjectsAtIndexes:indexes];
        }
}

- (void)replaceObject:(id)object withObject:(id)anObject
{
        if (!object || !anObject) {
                return;
        }
        NSUInteger index = [self indexOfObject:object];
        if (index != NSNotFound) {
                self[index] = anObject;
        }
}

@end
