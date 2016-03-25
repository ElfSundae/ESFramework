//
//  NSOrderedSet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @see NSArray(ESAdditions)
 */
@interface NSOrderedSet (ESAdditions)

- (BOOL)isEmpty;
- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block option:(NSEnumerationOptions)option;

- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx))predicate;
- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx))predicate option:(NSEnumerationOptions)option;

- (id)matchObject:(BOOL (^)(id obj, NSUInteger idx))predicate;
- (id)matchObject:(BOOL (^)(id obj, NSUInteger idx))predicate option:(NSEnumerationOptions)option;


- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option;

- (NSOrderedSet *)matchesOrderedSets:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSOrderedSet *)matchesOrderedSets:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option;

@end

@interface NSMutableOrderedSet (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option;

@end