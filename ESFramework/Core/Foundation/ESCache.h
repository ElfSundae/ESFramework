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
 * `ESCache` is a thread safe key&value store. It can be used as a normal `NSDictionary`, and it is
 * useful to share data between objects.
 *
 * Access is natively asynchronous. Every method accepts a callback block that runs on a concurrent
 * `queue`, with cache writes protected by GCD barriers.
 *
 * `ESCache` instance can be also cached to disk, see (File Methods).
 */
@interface ESCache : NSObject
{
        dispatch_queue_t _queue; // DISPATCH_QUEUE_CONCURRENT
}

ES_SINGLETON_DEC(sharedCache);

@property (nonatomic, copy, readonly) NSString *name;

- (instancetype)initWithName:(NSString *)name;

///=============================================
/// @name Asynchronous Methods
///=============================================

- (void)objectForKey:(NSString *)key block:(ESCacheObjectBlock)block;
- (void)setObject:(id)object forKey:(NSString *)key block:(ESCacheObjectBlock)block;
- (void)removeObjectForKey:(NSString *)key block:(ESCacheObjectBlock)block;
- (void)removeAllObjects:(ESCacheBlock)block;
- (void)enumerateObjectsWithBlock:(ESCacheEnumerationBlock)block completion:(ESCacheBlock)completionBlock;
- (void)save:(ESCacheBlock)block;

///=============================================
/// @name Synchronous Methods
///=============================================

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;
- (void)enumerateObjectsWithBlock:(ESCacheEnumerationBlock)block;
/**
 * `-save` will be called automatically when app enters background, 
 * or after `-removeAllObjects:` called.
 */
- (void)save;

- (NSString *)stringForKey:(NSString *)key;
- (NSURL *)URLForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;

///=============================================
/// @name Subclass
///=============================================

/**
 * Returns `nil` if there's no disk cache, default is `name.cache`,
 * the cache file is loacated in 'Library/Caches/ESCache'
 */
- (NSString *)diskCacheFileName;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESMemoryCache

/**
 * Cached only in memory.
 */
@interface ESMemoryCache : ESCache
@end
