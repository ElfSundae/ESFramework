//
//  ESCache.h
//  ESFramework
//
//  Created by Elf Sundae on 5/15/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDefines.h"
@class ESCache;

typedef void (^ESCacheBlock)(ESCache *cache);
typedef void (^ESCacheObjectBlock)(ESCache *cache, NSString *key, id object);
typedef void (^ESCacheEnumerationBlock)(ESCache *cache, NSString *key, id object, BOOL *stop);

/**
 * `ESCache` is a thread safe key&value store.
 *
 * Access is natively asynchronous. Every method accepts a callback block that runs on a concurrent
 * `queue`, with cache writes protected by GCD barriers.
 */
@interface ESCache : NSObject
{
        NSString *_name;
        dispatch_queue_t _queue; // DISPATCH_QUEUE_CONCURRENT
        NSMutableDictionary *_dictionary;
}

@property (nonatomic, copy, readonly) NSString *name;
- (instancetype)initWithName:(NSString *)name;

ES_SINGLETON_DEC(sharedCache);

///=============================================
/// @name Asynchronous Methods
///=============================================

- (void)objectForKey:(NSString *)key block:(ESCacheObjectBlock)block;
- (void)setObject:(id)object forKey:(NSString *)key block:(ESCacheObjectBlock)block;
- (void)removeObjectForKey:(NSString *)key block:(ESCacheObjectBlock)block;
- (void)removeAllObjects:(ESCacheBlock)block;
- (void)enumerateObjectsWithBlock:(ESCacheEnumerationBlock)block completion:(ESCacheBlock)completionBlock;

///=============================================
/// @name Synchronous Methods
///=============================================

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;
- (void)enumerateObjectsWithBlock:(ESCacheEnumerationBlock)block;

@end
