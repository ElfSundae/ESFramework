//
//  NSDictionary+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ESAdditions)

/**
 * If the object is [NSNull null], it will returns #nil.
 * It is useful while accessing a JSONObject which parsed
 * from JSON data.
 */
- (id)smartObjectForKey:(id)key;

- (void)each:(void (^)(id key, id obj))block;

- (void)eachReversely:(void (^)(id key, id obj))block;
/**
 * @see NSArray -each_concurrently
 */
- (void)eachConcurrently:(void (^)(id key, id obj))block;

/**
 * Returns the key that first matchs the block;
 */
- (id)match:(BOOL (^)(id key, id obj))block;
/**
 * Loops through to find the objects that matching the block, 
 * returns key/value pairs dictionary.
 */
- (NSDictionary *)matches:(BOOL (^)(id key, id obj))block;

@end

@interface NSMutableDictionary (ESAdditions)
- (void)matchWith:(BOOL (^)(id key, id obj))block;
- (void)rejectWith:(BOOL (^)(id key, id obj))block;
@end
