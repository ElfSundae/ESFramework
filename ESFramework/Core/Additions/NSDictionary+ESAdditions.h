//
//  NSDictionary+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary<KeyType, ObjectType> (ESAdditions)

- (BOOL)isEmpty;

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
