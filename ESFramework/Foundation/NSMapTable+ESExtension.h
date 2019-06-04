//
//  NSMapTable+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/06/05.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMapTable<KeyType, ObjectType> (ESExtension)

/**
 * Returns the value associated with the given key.
 */
- (nullable ObjectType)objectForKeyedSubscript:(nullable KeyType)key;

/**
 * Adds a given key-value pair to the map table.
 */
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(nullable KeyType)key;

/**
 * Returns all keys.
 */
@property (readonly, copy) NSArray<KeyType> *allKeys;

/**
 * Returns all values.
 */
@property (readonly, copy) NSArray<ObjectType> *allValues;

@end

NS_ASSUME_NONNULL_END
