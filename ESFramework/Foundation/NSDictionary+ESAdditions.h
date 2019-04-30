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
 * Creates a percent encoded URL query string from this dictionary.
 *
 * For example, @{ @"foo": @123, @"bar": @[ @"a", @"b" ] } will return
 * @"foo=123&bar%5B%5D=a&bar%5B%5D=b"
 */
- (NSString *)URLQueryString;

- (NSDictionary<KeyType, ObjectType> *)entriesPassingTest:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))predicate;
- (NSDictionary<KeyType, ObjectType> *)entriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(KeyType key, ObjectType obj, BOOL *stop))predicate;

@end

#pragma mark - NSMutableDictionary (ESAdditions)

@interface NSMutableDictionary (ESAdditions)

/**
 * Set an object for the property identified by a given key path to a given value.
 *
 * @param    object                  The object for the property identified by _keyPath_.
 * @param    keyPath                 A key path of the form _relationship.property_ (with one or more relationships): for example “department.name” or “department.manager.lastName.”
 */
- (void)setObject:(id)object forKeyPath:(NSString *)keyPath;

/**
 * Set an object for the property identified by a given key path to a given value, with optional parameters to control creation and replacement of intermediate objects.
 *
 * @param    object                  The object for the property identified by _keyPath_.
 * @param    keyPath                 A key path of the form _relationship.property_ (with one or more relationships): for example “department.name” or “department.manager.lastName.”
 * @param    createIntermediates     Intermediate dictionaries defined within the key path that do not currently exist in the receiver are created.
 * @param    replaceIntermediates    Intermediate objects encountered in the key path that are not a direct subclass of `NSDictionary` are replaced.
 */
- (void)setObject:(id)object forKeyPath:(NSString *)keyPath createIntermediateDictionaries:(BOOL)createIntermediates replaceIntermediateObjects:(BOOL)replaceIntermediates;

@end

NS_ASSUME_NONNULL_END
