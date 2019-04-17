//
//  NSArray+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-17.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ESAdditions)

- (BOOL)isEmpty;

/**
 * Find matched object index via passing test predicate block.
 */
- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx))predicate;
- (NSUInteger)match:(BOOL (^)(id obj, NSUInteger idx))predicate option:(NSEnumerationOptions)option;

/**
 * Returns nil if matching failed.
 */
- (id)matchObject:(BOOL (^)(id obj, NSUInteger idx))predicate;
- (id)matchObject:(BOOL (^)(id obj, NSUInteger idx))predicate option:(NSEnumerationOptions)option;

- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSIndexSet *)matches:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option;

- (NSArray *)matchesObjects:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)matchesObjects:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option;

/**
 * Asynchronously write file.
 * It will create directories automatically if not exists.
 */
- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile completion:(void (^)(BOOL result))completion;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableArray

@interface NSMutableArray (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate option:(NSEnumerationOptions)option;
- (void)replaceObject:(id)object withObject:(id)anObject;

@end
