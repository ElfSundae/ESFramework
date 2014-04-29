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
- (void)each:(void (^)(id obj, NSUInteger idx))block;
/**
 * Enumerates (Block Enumeration) through an array *reversely* and executes the given block with each object.
 */
- (void)eachReversely:(void (^)(id obj, NSUInteger idx))block;
/**
 * Enumerates (Block Enumeration) through an array *concurrently* and executes the given block with each object.
 *
 * Enumeration will occur on appropriate background queues. This
 * will have a noticeable speed increase, especially on dual-core
 * devices, but you *must* be aware of the thread safety of the
 * objects you message from within the block. Be aware that the
 * order of objects is not necessarily the order each block will
 * be called in.
 *
 * @see http://darkdust.net/writings/objective-c/nsarray-enumeration-performance
 * @see cn_zh: http://www.oschina.net/translate/nsarray-enumeration-performance
 */
- (void)eachConcurrently:(void (^)(id obj))block;
/**
 * Loops through an array to find the object that first matching the block.
 */
- (id)match:(BOOL (^)(id obj, NSUInteger idx))block;
/**
 * Loops through an array to find the objects that matching the block.
 */
- (NSArray *)matches:(BOOL (^)(id obj, NSUInteger idx))block;
/**
 * Loops through an array to find the objects that does not match the block.
 */
- (NSArray *)reject:(BOOL (^)(id obj, NSUInteger idx))block;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableArray
@interface NSMutableArray (ESAdditions)
- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx))block;
- (void)rejectWith:(BOOL (^)(id obj, NSUInteger idx))block;
@end
