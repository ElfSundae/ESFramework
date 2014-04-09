//
//  NSUserDefaults+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ESAdditions)

/**
 * Get object for the given key.
 */
+ (id)objectForKey:(NSString *)key;
/**
 * Async saving object.
 */
+ (void)setObject:(id)object forKey:(NSString *)key;
/**
 * Async removing object.
 */
+ (void)removeObjectForKey:(NSString *)key;


@end
