//
//  NSArray+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-17.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSArray+ESAdditions.h"

@implementation NSArray (ESAdditions)

- (id)objectPassingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectWithOptions:0 passingTest:predicate];
}

- (id)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate
{
    NSUInteger index = [self indexOfObjectWithOptions:opts passingTest:predicate];
    return NSNotFound != index ? self[index] : nil;
}

- (NSArray *)objectsPassingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectsWithOptions:0 passingTest:predicate];
}

- (NSArray *)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectsAtIndexes:[self indexesOfObjectsWithOptions:opts passingTest:predicate]];
}

- (id)previousObjectToIndex:(NSUInteger)index
{
    index--;
    return (index >= 0 && index < self.count) ? self[index] : nil;
}

- (id)previousObjectToObject:(id)object
{
    return [self previousObjectToIndex:[self indexOfObject:object]];
}

- (id)nextObjectToIndex:(NSUInteger)index
{
    index++;
    return (index >= 0 && index < self.count) ? self[index] : nil;
}

- (id)nextObjectToObject:(id)object
{
    return [self nextObjectToIndex:[self indexOfObject:object]];
}

@end
