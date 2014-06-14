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

- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
        return [self indexOfObjectPassingTest:predicate];
}

- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        return [self indexOfObjectWithOptions:option passingTest:predicate];
}

- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate
{
        return [self indexesOfObjectsPassingTest:predicate];
}

- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        return [self indexesOfObjectsWithOptions:option passingTest:predicate];
}


- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESWeakSelf;
        ESDispatchOnDefaultQueue(^{
                ESStrongSelf;
                NSString *filePath = ESTouchFilePath(path);
                if (!filePath) {
                        if (block) {
                                block(NO);
                        }
                } else {
                        BOOL res = [_self writeToFile:filePath atomically:useAuxiliaryFile];
                        if (block) {
                                block(res);
                        }
                }
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
