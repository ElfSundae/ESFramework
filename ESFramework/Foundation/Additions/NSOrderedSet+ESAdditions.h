//
//  NSOrderedSet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOrderedSet (ESAdditions)
- (void)each:(void (^)(id obj, NSUInteger idx))block;
- (void)eachReversely:(void (^)(id obj, NSUInteger idx))block;
- (void)eachConcurrently:(void (^)(id obj))block;
- (id)match:(BOOL (^)(id obj))block;
- (NSOrderedSet *)matches:(BOOL (^)(id obj, NSUInteger idx))block;
- (NSOrderedSet *)reject:(BOOL (^)(id obj, NSUInteger idx))block;
@end

@interface NSMutableOrderedSet (ESAdditions)
- (void)matchWith:(BOOL (^)(id obj, NSUInteger idx))block;
- (void)rejectWith:(BOOL (^)(id obj, NSUInteger idx))block;
@end