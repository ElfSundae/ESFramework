//
//  NSOrderedSet+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2014/04/18.
//  Copyright © 2014 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSOrderedSet<ObjectType> (ESExtension)

- (nullable ObjectType)objectOrNilAtIndex:(NSUInteger)index;

- (nullable ObjectType)objectPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (nullable ObjectType)objectWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

- (NSArray<ObjectType> *)objectsPassingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray<ObjectType> *)objectsWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(ObjectType obj, NSUInteger idx, BOOL *stop))predicate;

@end

NS_ASSUME_NONNULL_END
