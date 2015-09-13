//
//  NSSet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSSet+ESAdditions.h"
#import "ESDefines.h"

@implementation NSSet (ESAdditions)

- (BOOL)isEmpty
{
        return (0 == self.count);
}

- (void)each:(void (^)(id obj, BOOL *stop))block
{
        [self enumerateObjectsUsingBlock:block];
}
- (void)each:(void (^)(id obj, BOOL *stop))block option:(NSEnumerationOptions)option
{
        [self enumerateObjectsWithOptions:option usingBlock:block];
}

- (id)match:(BOOL (^)(id obj))predicate
{
        NSParameterAssert(predicate);
        NSSet *set = [self matches:^BOOL(id obj_, BOOL *stop) {
                if (predicate(obj_)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        }];
        return [set anyObject];
}

- (id)match:(BOOL (^)(id obj))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSSet *set = [self matches:^BOOL(id obj_, BOOL *stop) {
                if (predicate(obj_)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        } option:option];
        return [set anyObject];
}

- (NSSet *)matches:(BOOL (^)(id obj, BOOL *stop))predicate
{
        return [self objectsPassingTest:predicate];
}

- (NSSet *)matches:(BOOL (^)(id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        return [self objectsWithOptions:option passingTest:predicate];
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation NSMutableSet (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, BOOL *stop))predicate
{
        NSParameterAssert(predicate);
        [self setSet:[self matches:predicate]];
}
- (void)matchWith:(BOOL (^)(id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        [self setSet:[self matches:predicate option:option]];
}

@end
