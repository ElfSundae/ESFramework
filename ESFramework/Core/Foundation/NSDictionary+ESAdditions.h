//
//  NSDictionary+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @see NSArray(ESAdditions)
 */
@interface NSDictionary (ESAdditions)

- (BOOL)isEmpty;
/**
 * If the object is `[NSNull null]`, it will returns `nil`.
 * It is useful when accessing a JSONObject which parsed from JSON data.
 */
- (id)esObjectForKey:(id)key;

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

/**
 * Asynchronously write file.
 * It will create directories automatically if not exists.
 */
- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block;


@end

@interface NSMutableDictionary (ESAdditions)
- (void)matchWith:(BOOL (^)(id key, id obj))block;
- (void)rejectWith:(BOOL (^)(id key, id obj))block;
@end
