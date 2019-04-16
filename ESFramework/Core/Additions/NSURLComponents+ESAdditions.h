//
//  NSURLComponents+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/16.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLComponents (ESAdditions)

/**
 * Add query items to the current URL components.
 */
- (void)addQueryItems:(NSArray<NSURLQueryItem *> *)queryItems;

/**
 * Add a query item to the current URL components.
 */
- (void)addQueryItem:(NSURLQueryItem *)item;

/**
 * Add a query item with the given name-value pair.
 */
- (void)addQueryItemWithName:(NSString *)name value:(NSString *)value;

/**
 * Remove query items with the given item names.
 */
- (void)removeQueryItemsWithNames:(NSArray<NSString *> *)names;

/**
 * Remove query items with the given item name.
 */
- (void)removeQueryItemsWithName:(NSString *)name;

/**
 * Gets and sets query items via a dictionary, it supports array in the query parameter like
 * ?foo=bar&foo=bar1&foo[]=bar2
 */
@property (copy) NSDictionary<NSString *, id> *queryItemsDictionary;

/**
 * Add query items via the given dictionary.
 */
- (void)addQueryItemsDictionary:(NSDictionary<NSString *, id> *)dictionary;

@end
