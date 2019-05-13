//
//  NSDictionary+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<KeyType, ObjectType> (ESAdditions)

/**
 * Returns a new dictionary containing the entries for the specified keys.
 */
- (NSDictionary<KeyType, ObjectType> *)entriesForKeys:(NSSet<KeyType> *)keys;

/**
 * Creates a percent encoded URL query string from this dictionary.
 *
 * For example, @{ @"foo": @123, @"bar": @[ @"a", @"b" ] } will return
 * @"foo=123&bar%5B%5D=a&bar%5B%5D=b"
 */
- (NSString *)URLQueryString;

- (NSDictionary<KeyType, ObjectType> *)entriesPassingTest:(BOOL (NS_NOESCAPE ^)(KeyType key, ObjectType obj, BOOL *stop))predicate;
- (NSDictionary<KeyType, ObjectType> *)entriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(KeyType key, ObjectType obj, BOOL *stop))predicate;

@end

#pragma mark - NSMutableDictionary (ESAdditions)

@interface NSMutableDictionary (ESAdditions)

/**
 * Sets an object for the key path that formed nested "dot" notation.
 */
- (void)setObject:(id)object forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
