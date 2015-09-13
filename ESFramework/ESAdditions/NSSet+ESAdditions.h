//
//  NSSet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @see NSArray(ESAdditions)
 */
@interface NSSet (ESAdditions)

- (BOOL)isEmpty;

- (void)each:(void (^)(id obj, BOOL *stop))block;
- (void)each:(void (^)(id obj, BOOL *stop))block option:(NSEnumerationOptions)option;

- (id)match:(BOOL (^)(id obj))predicate;
- (id)match:(BOOL (^)(id obj))predicate option:(NSEnumerationOptions)option;

- (NSSet *)matches:(BOOL (^)(id obj, BOOL *stop))predicate;
- (NSSet *)matches:(BOOL (^)(id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option;

@end

@interface NSMutableSet (ESAdditions)

- (void)matchWith:(BOOL (^)(id obj, BOOL *stop))predicate;
- (void)matchWith:(BOOL (^)(id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option;

@end
