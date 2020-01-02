//
//  NSURLComponents+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/16.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLComponents (ESExtension)

/**
 * Add query items to the URL components.
 */
- (void)addQueryItems:(NSArray<NSURLQueryItem *> *)queryItems;

/**
 * Add a query item to the URL components.
 */
- (void)addQueryItem:(NSURLQueryItem *)item;

/**
 * Add a query item with the given name-value pair to the URL components.
 */
- (void)addQueryItemWithName:(NSString *)name value:(nullable NSString *)value;

/**
 * Remove query items with the given item names.
 */
- (void)removeQueryItemsWithNames:(NSArray<NSString *> *)names;

/**
 * Remove query items with the given item name.
 */
- (void)removeQueryItemsWithName:(NSString *)name;

/**
 * The query URL component as a dictionary.
 * @discussion The value of a query parameter could be NSString, NSNumber, NSNull, NSArray.
 */
@property (nullable, copy) NSDictionary<NSString *, id> *queryParameters;

/**
 * Add query parameters.
 */
- (void)addQueryParameters:(NSDictionary<NSString *, id> *)parameters;

@end

NS_ASSUME_NONNULL_END
