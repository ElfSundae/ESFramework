//
//  NSOrderedSet+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/18.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "NSOrderedSet+ESExtension.h"

@implementation NSOrderedSet (ESExtension)

- (id)objectOrNilAtIndex:(NSUInteger)index
{
    return index < self.count ? self[index] : nil;
}

- (id)objectPassingTest:(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectWithOptions:0 passingTest:predicate];
}

- (id)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id, NSUInteger, BOOL *))predicate
{
    return [self objectOrNilAtIndex:[self indexOfObjectWithOptions:opts passingTest:predicate]];
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
