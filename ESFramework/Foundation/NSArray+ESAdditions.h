//
//  NSArray+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-17.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (ESAdditions)

- (nullable ObjectType)objectOrNilAtIndex:(NSUInteger)index;
- (nullable ObjectType)randomObject;

- (NSArray<ObjectType> *)reversedArray;

- (nullable ObjectType)objectPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (nullable ObjectType)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

- (NSArray<ObjectType> *)objectsPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray<ObjectType> *)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

- (nullable ObjectType)previousObjectToIndex:(NSUInteger)index;
- (nullable ObjectType)previousObjectToObject:(ObjectType)object;
- (nullable ObjectType)nextObjectToIndex:(NSUInteger)index;
- (nullable ObjectType)nextObjectToObject:(ObjectType)object;

@end

#pragma mark - NSMutableArray (ESAdditions)

@interface NSMutableArray<ObjectType> (ESAdditions)

/**
 * Removes the first object in the array.
 */
- (void)removeFirstObject;

/**
 * Removes and returns the first object.
 */
- (nullable ObjectType)shiftFirstObject;

/**
 * Removes and returns the last object.
 */
- (nullable ObjectType)popLastObject;

/**
 * Replaces the object in the array with anObject.
 */
- (BOOL)replaceObject:(ObjectType)object withObject:(ObjectType)anObject;

/**
 * Reverses objects in the array.
 */
- (void)reverseObjects;

/**
 * Shuffles objects in the array.
 */
- (void)shuffleObjects;

@end

NS_ASSUME_NONNULL_END
