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

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ES_WEAK_VAR(self, weakSelf);
        ESDispatchOnDefaultQueue(^{
                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                NSString *filePath = ESTouchFilePath(path);
                if (!filePath) {
                        if (block) {
                                block(NO);
                        }
                        return;
                }
                
                BOOL res = [_self writeToFile:filePath atomically:useAuxiliaryFile];
                if (block) {
                        block(res);
                }
        });
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
