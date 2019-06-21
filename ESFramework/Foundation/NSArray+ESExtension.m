//
//  NSArray+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/17.
//  Copyright (c) 2014 https://0x123.com All rights reserved.
//

#import "NSArray+ESExtension.h"

@implementation NSArray (ESExtension)

- (id)objectOrNilAtIndex:(NSUInteger)index
{
    return index < self.count ? self[index] : nil;
}

- (id)randomObject
{
    return self.count ? self[arc4random_uniform((uint32_t)self.count)] : nil;
}

- (NSArray *)arrayByReversingObjects
{
    return self.reverseObjectEnumerator.allObjects;
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

- (id)previousObjectToIndex:(NSUInteger)index
{
    return [self objectOrNilAtIndex:index - 1];
}

- (id)previousObjectToObject:(id)object
{
    return [self previousObjectToIndex:[self indexOfObject:object]];
}

- (id)nextObjectToIndex:(NSUInteger)index
{
    return [self objectOrNilAtIndex:index + 1];
}

- (id)nextObjectToObject:(id)object
{
    return [self nextObjectToIndex:[self indexOfObject:object]];
}

@end

#pragma mark - NSMutableArray (ESExtension)

@implementation NSMutableArray (ESExtension)

- (void)removeFirstObject
{
    if (self.count) {
        [self removeObjectAtIndex:0];
    }
}

- (id)shiftFirstObject
{
    id object = self.firstObject;
    [self removeFirstObject];
    return object;
}

- (id)popLastObject
{
    id object = self.lastObject;
    [self removeLastObject];
    return object;
}

- (BOOL)replaceObject:(id)object withObject:(id)anObject
{
    NSUInteger index = [self indexOfObject:object];
    if (index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
        return YES;
    }
    return NO;
}

- (void)reverseObjects
{
    if (self.count < 2) {
        return;
    }

    NSUInteger i = 0;
    NSUInteger j = self.count - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i++ withObjectAtIndex:j--];
    }
}

- (void)shuffleObjects
{
    for (NSUInteger i = self.count; i > 1; i--) {
        [self exchangeObjectAtIndex:i - 1 withObjectAtIndex:arc4random_uniform((uint32_t)i)];
    }
}

@end
