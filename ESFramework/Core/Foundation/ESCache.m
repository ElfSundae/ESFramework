//
//  ESCache.m
//  ESFramework
//
//  Created by Elf Sundae on 5/15/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESCache.h"
#import "ESValue.h"

@interface ESCache ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong) __attribute__((NSObject)) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation ESCache
@synthesize name = _name,
queue = _queue,
dictionary = _dictionary;

+ (instancetype)sharedCache
{
        static ESCache *__gSharedCache = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                NSString *name = [NSString stringWithFormat:@"%@_sharedCache", NSStringFromClass([self class])];
                __gSharedCache = [[self alloc] initWithName:name];
        });
        return __gSharedCache;
}

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                
                NSString *cacheFile = [self _diskCacheFilePath];
                if (cacheFile) {
                        id cacheObject = [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFile];
                        if ([cacheObject isKindOfClass:[NSDictionary class]]) {
                                [_dictionary addEntriesFromDictionary:(NSDictionary *)cacheObject];
                        }
                        ESWeak(self, weakSelf);
                        [self addNotification:UIApplicationDidEnterBackgroundNotification handler:^(NSNotification *notification, NSDictionary *userInfo) {
                                ESStrong(weakSelf, _self);
                                [_self save];
                        }];
                }
        }
        return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (NSString *)name
{
        __block NSString *name_ = nil;
        dispatch_sync(_queue, ^{
                name_ = _name;
        });
        return name_;
}

- (void)setName:(NSString *)name
{
        ESWeak(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ESStrong(weakSelf, _self);
                _self->_name = name;
        });
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (NSString *)diskCacheFileName
{
        return [NSString stringWithFormat:@"%@.%@.cache", NSStringFromClass(self.class), _name];
}

- (NSString *)_diskCacheFilePath
{
        static NSString *_gDiskCacheFilePath = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
                NSString *filename = self.diskCacheFileName;
                if (filename) {
                        _gDiskCacheFilePath = ESTouchFilePath(ESPathForCachesResource(@"ESCache/%@", filename));
                }
        });
        return _gDiskCacheFilePath;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Asynchronous Methods

- (void)objectForKey:(NSString *)key block:(ESCacheObjectBlock)block
{
        if (!key || !block) {
                return;
        }
        ESWeak(self, weakSelf);
        dispatch_async(_queue, ^{
                ESStrong(weakSelf, _self);
                id object = (_self.dictionary)[key];
                block(_self, key, object);
        });
}

- (void)setObject:(id)object forKey:(NSString *)key block:(ESCacheObjectBlock)block
{
        if (!key || !object) {
                return;
        }
        ESWeak(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ESStrong(weakSelf, _self);
                (_self.dictionary)[key] = object;
                
                if (block) {
                        dispatch_async(_self->_queue, ^{
                              ESStrong(weakSelf, _self);
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
        ESWeak(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ESStrong(weakSelf, _self);
                [_self.dictionary removeObjectForKey:key];
                
                if (block) {
                        dispatch_async(_self->_queue, ^{
                                ESStrong(weakSelf, _self);
                                block(_self, key, nil);
                        });
                }
        });
}

- (void)removeAllObjects:(ESCacheBlock)block
{
        ESWeak(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ESStrong(weakSelf, _self);
                [_self.dictionary removeAllObjects];
                if ([_self _diskCacheFilePath]) {
                        [[NSFileManager defaultManager] removeItemAtPath:[_self _diskCacheFilePath] error:NULL];
                }
                if (block) {
                        dispatch_async(_self->_queue, ^{
                                ESStrong(weakSelf, _self);
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
        ESWeak(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ESStrong(weakSelf, _self);
                for (NSString *key in _self.dictionary) {
                        BOOL stop = NO;
                        block(_self, key, (_self.dictionary)[key], &stop);
                        if (stop) {
                                break;
                        }
                }
                
                if (completionBlock) {
                        dispatch_async(_self->_queue, ^{
                                ESStrong(weakSelf, _self);
                                completionBlock(_self);
                        });
                }
        });
}

- (void)save:(ESCacheBlock)block
{
        ESWeak(self, weakSelf);
        dispatch_barrier_async(_queue, ^{
                ESStrong(weakSelf, _self);
                if ([_self _diskCacheFilePath]) {
                        if (_self.dictionary.count) {
                                [NSKeyedArchiver archiveRootObject:_self.dictionary toFile:[_self _diskCacheFilePath]];
                        } else {
                                [[NSFileManager defaultManager] removeItemAtPath:[_self _diskCacheFilePath] error:NULL];
                        }
                }
                if (block) {
                        dispatch_async(_self->_queue, ^{
                                ESStrong(weakSelf, _self);
                                block(_self);
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

- (void)save
{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self save:^(ESCache *cache) {
                dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
}


- (NSString *)stringForKey:(NSString *)key
{
        __autoreleasing NSString *result = nil;
        ESStringVal(&result, [self objectForKey:key]);
        return result;
}
- (NSURL *)URLForKey:(NSString *)key
{
        __autoreleasing NSURL *result = nil;
        ESURLVal(&result, [self objectForKey:key]);
        return result;
}
- (NSArray *)arrayForKey:(NSString *)key
{
        NSArray *result = [self objectForKey:key];
        return ([result isKindOfClass:[NSArray class]] ? result : nil);
}
- (NSDictionary *)dictionaryForKey:(NSString *)key
{
        NSDictionary *result = [self objectForKey:key];
        return ([result isKindOfClass:[NSDictionary class]] ? result : nil);
}
- (NSData *)dataForKey:(NSString *)key
{
        NSData *result = [self objectForKey:key];
        return ([result isKindOfClass:[NSData class]] ? result : nil);
}
- (NSInteger)integerForKey:(NSString *)key
{
        NSInteger result = 0;
        ESIntegerVal(&result, [self objectForKey:key]);
        return result;
        
}
- (float)floatForKey:(NSString *)key
{
        float result = 0.f;
        ESFloatVal(&result, [self objectForKey:key]);
        return result;
}
- (double)doubleForKey:(NSString *)key
{
        double result = 0.0;
        ESDoubleVal(&result, [self objectForKey:key]);
        return result;
}
- (BOOL)boolForKey:(NSString *)key
{
        BOOL result = NO;
        ESBoolVal(&result, [self objectForKey:key]);
        return result;
}

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESMemoryCache

@implementation ESMemoryCache
- (NSString *)diskCacheFileName
{
        return nil;
}
@end