//
//  NSOrderedSet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSOrderedSet+ESAdditions.h"

@implementation NSOrderedSet (ESAdditions)

- (id)objectPassingTest:(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectWithOptions:0 passingTest:predicate];
}

- (id)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL *))predicate
{
    NSUInteger index = [self indexOfObjectWithOptions:opts passingTest:predicate];
    return NSNotFound != index ? self[index] : nil;
}

- (NSArray *)objectsPassingTest:(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectsWithOptions:0 passingTest:predicate];
}

- (NSArray *)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectsAtIndexes:[self indexesOfObjectsWithOptions:opts passingTest:predicate]];
}

@end
