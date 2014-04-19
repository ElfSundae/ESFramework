//
//  NSSet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSSet+ESAdditions.h"

@implementation NSSet (ESAdditions)

- (void)each:(void (^)(id obj))block
{
        NSParameterAssert(block);
        [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                block(obj);
        }];
}

- (void)eachConcurrently:(void (^)(id obj))block
{
        NSParameterAssert(block);
        [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, BOOL *stop) {
                block(obj);
        }];
}

- (id)match:(BOOL (^)(id obj))block
{
        NSParameterAssert(block);
        NSSet *set = [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                if (block(obj)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        }];
        return [set anyObject];
}

- (NSSet *)matches:(BOOL (^)(id obj))block
{
        NSParameterAssert(block);
        return [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                return block(obj);
        }];
}

- (NSSet *)reject:(BOOL (^)(id obj))block
{
        NSParameterAssert(block);
        return [self objectsPassingTest:^BOOL(id obj, BOOL *stop) {
                return !block(obj);
        }];
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation NSMutableSet (ESAdditions)
- (void)matchWith:(BOOL (^)(id obj))block
{
        [self setSet:[self matches:block]];
}
- (void)rejectWith:(BOOL (^)(id obj))block
{
        [self matchWith:^BOOL(id obj) {
                return !block(obj);
        }];
}
@end
