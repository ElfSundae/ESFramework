//
//  NSArray+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/17.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (ESExtension)

- (nullable ObjectType)objectOrNilAtIndex:(NSUInteger)index;
- (nullable ObjectType)randomObject;

- (NSArray<ObjectType> *)arrayByReversingObjects;

- (nullable ObjectType)objectPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (nullable ObjectType)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

- (NSArray<ObjectType> *)objectsPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray<ObjectType> *)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

- (nullable ObjectType)previousObjectToIndex:(NSUInteger)index;
- (nullable ObjectType)previousObjectToObject:(ObjectType)object;
- (nullable ObjectType)nextObjectToIndex:(NSUInteger)index;
- (nullable ObjectType)nextObjectToObject:(ObjectType)object;

- (nullable NSString *)JSONString;
- (nullable NSString *)JSONStringWithOptions:(NSJSONWritingOptions)opts;

@end

#pragma mark - NSMutableArray (ESExtension)

@interface NSMutableArray<ObjectType> (ESExtension)

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
