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

- (void)each:(void (^)(id key, id obj, BOOL *stop))block;
- (void)each:(void (^)(id key, id obj, BOOL *stop))block option:(NSEnumerationOptions)option;

/**
 * Matches using predicating block, returns the key.
 */
- (id)match:(BOOL (^)(id key, id obj))predicate;
- (id)match:(BOOL (^)(id key, id obj))predicate option:(NSEnumerationOptions)option;

/**
 * Returns nil if matching failed.
 */
- (NSDictionary *)matchDictionary:(BOOL (^)(id key, id obj))predicate;
- (NSDictionary *)matchDictionary:(BOOL (^)(id key, id obj))predicate option:(NSEnumerationOptions)option;

/**
 * Matches using predicating block, returns the keys.
 */
- (NSSet *)matches:(BOOL (^)(id key, id obj, BOOL *stop))predicate;
- (NSSet *)matches:(BOOL (^)(id key, id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option;

/**
 * Matches using predicating block, returns the keys and objects.
 */
- (NSDictionary *)matchesDictionary:(BOOL (^)(id key, id obj, BOOL *stop))predicate;
- (NSDictionary *)matchesDictionary:(BOOL (^)(id key, id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option;

/**
 * Asynchronously write file.
 * It will create directories automatically if not exists.
 */
- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block;


@end

@interface NSMutableDictionary (ESAdditions)
- (void)matchWith:(BOOL (^)(id key, id obj, BOOL *stop))predicate;
- (void)matchWith:(BOOL (^)(id key, id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option;
@end
