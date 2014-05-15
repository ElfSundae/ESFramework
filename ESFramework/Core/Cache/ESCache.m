//
//  ESCache.m
//  ESFramework
//
//  Created by Elf Sundae on 5/15/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESCache.h"

@interface ESCache ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong) __attribute__((NSObject)) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation ESCache

ES_SINGLETON_IMP_AS(sharedCache, initWithName:@"sharedCache");

- (void)dealloc
{
        if (_queue) {
                dispatch_release(_queue);
                _queue = NULL;
        }
}

- (instancetype)initWithName:(NSString *)name
{
        self = [super init];
        if (self) {
                _name = name;
                NSString *queueName = [NSString stringWithFormat:@"com.ESCache.%@.%p", name, self];
                _queue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_CONCURRENT);
                
                _dictionary = [[NSMutableDictionary alloc] init];
        }
        return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Asynchronous Methods

- (void)objectForKey:(NSString *)key block:(ESCacheObjectBlock)block
{
        if (!key || !block) {
                return;
        }
        ES_WEAK_VAR(self, weakSelf);
        dispatch_async(_queue, ^{
                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                id object = [_self.dictionary objectForKey:key];
                block(_self, key, object);
        });
}

- (void)setObject:(id)object forKey:(NSString *)key block:(ESCacheObjectBlock)block
{
        if (!key || !object) {
                return;
        }
        ES_WEAK_VAR(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                [_self.dictionary setObject:object forKey:key];
                
                if (block) {
                        dispatch_async(_self->_queue, ^{
                              ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                                block(_self, key, object);
                        });
                }
        });
}

- (void)removeObjectForKey:(NSString *)key block:(ESCacheObjectBlock)block
{
        if (!key) {
                return;
        }
        ES_WEAK_VAR(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                [_self.dictionary removeObjectForKey:key];
                
                if (block) {
                        dispatch_async(_self->_queue, ^{
                                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                                block(_self, key, nil);
                        });
                }
        });
}

- (void)removeAllObjects:(ESCacheBlock)block
{
        ES_WEAK_VAR(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                [_self.dictionary removeAllObjects];
                
                if (block) {
                        dispatch_async(_self->_queue, ^{
                                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                                block(_self);
                        });
                }
        });
}

- (void)enumerateObjectsWithBlock:(ESCacheEnumerationBlock)block completion:(ESCacheBlock)completionBlock
{
        if (!block) {
                return;
        }
        ES_WEAK_VAR(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                for (NSString *key in _self.dictionary) {
                        BOOL stop = NO;
                        block(_self, key, [_self.dictionary objectForKey:key], &stop);
                        if (stop) {
                                break;
                        }
                }
                
                if (completionBlock) {
                        dispatch_async(_self->_queue, ^{
                                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                                completionBlock(_self);
                        });
                }
        });
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Synchronous Methods

- (id)objectForKey:(NSString *)key
{
        if (!key) {
                return nil;
        }
        __block id objectForKey = nil;
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self objectForKey:key block:^(ESCache *cache, NSString *key, id object) {
                objectForKey = object;
                dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
        
        return objectForKey;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
        if (!object || !key) {
                return;
        }
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self setObject:object forKey:key block:^(ESCache *cache, NSString *key, id object) {
                dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
}

- (void)removeObjectForKey:(NSString *)key
{
        if (!key) {
                return;
        }
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self removeObjectForKey:key block:^(ESCache *cache, NSString *key, id object) {
                dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
}

- (void)removeAllObjects
{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self removeAllObjects:^(ESCache *cache) {
              dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
}

- (void)enumerateObjectsWithBlock:(ESCacheEnumerationBlock)block
{
        if (!block) {
                return;
        }
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self enumerateObjectsWithBlock:block completion:^(ESCache *cache) {
              dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
}

@end
