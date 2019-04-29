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

- (nullable ObjectType)objectPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (nullable ObjectType)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

- (NSArray<ObjectType> *)objectsPassingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray<ObjectType> *)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

- (nullable ObjectType)previousObjectToIndex:(NSUInteger)index;
- (nullable ObjectType)previousObjectToObject:(ObjectType)object;
- (nullable ObjectType)nextObjectToIndex:(NSUInteger)index;
- (nullable ObjectType)nextObjectToObject:(ObjectType)object;

@end

@interface NSMutableArray<ObjectType> (ESAdditions)

- (void)replaceObject:(ObjectType)object withObject:(ObjectType)anObject;

@end

NS_ASSUME_NONNULL_END
