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
 * Enumerates (Block Enumeration) through an array and executes the given block with each object.
 */
- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

/**
 * Enumerates (Block Enumeration) through an array and executes the given block with each object.
 *
 * If option is `NSEnumerationConcurrent`,
 * Enumeration will occur on appropriate background queues. This
 * will have a noticeable speed increase, especially on dual-core
 * devices, but you *must* be aware of the thread safety of the
 * objects you message from within the block. Be aware that the
 * order of objects is not necessarily the order each block will
 * be called in.
 *
 * @see NSArray enumeration performance examined: http://darkdust.net/writings/objective-c/nsarray-enumeration-performance
 * @see NSArray 枚举性能研究: http://www.oschina.net/translate/nsarray-enumeration-performance
 *
 */
- (void)each:(void (^)(id obj, NSUInteger idx, BOOL *stop))block option:(NSEnumerationOptions)option;

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
