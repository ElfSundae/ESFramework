//
//  NSDictionary+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDictionary+ESAdditions.h"
#import "NSString+ESAdditions.h"

@implementation NSDictionary (ESAdditions)

- (BOOL)isEmpty
{
        return (0 == self.count);
}

- (NSString *)queryString
{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in [self keyEnumerator]) {
                NSString *encodedKey = nil;
                if ([key isKindOfClass:[NSString class]]) {
                        encodedKey = [key URLEncode];
                } else if ([key isKindOfClass:[NSNumber class]]) {
                        encodedKey = [[(NSNumber *)key stringValue] URLEncode];
                } else {
                        continue;
                }
                
                id value = self[key];
                
                if ([value isKindOfClass:[NSArray class]]) {
                        for (id arr_obj in (NSArray *)value) {
                                NSString *arr_encoded_value = nil;
                                if ([arr_obj isKindOfClass:[NSNumber class]]) {
                                        arr_encoded_value = [[(NSNumber *)arr_obj stringValue] URLEncode];
                                } else if ([arr_obj isKindOfClass:[NSString class]]) {
                                        arr_encoded_value = [(NSString *)arr_obj URLEncode];
                                } else {
                                        continue;
                                }
                                [array addObject:[NSString stringWithFormat:@"%@[]=%@", encodedKey, arr_encoded_value]];
                        }
                        
                } else {
                        NSString *encodedValue = nil;
                        if ([value isKindOfClass:[NSString class]]) {
                                encodedValue = [(NSString *)value URLEncode];
                        } else if ([value isKindOfClass:[NSNumber class]]) {
                                encodedValue = [[(NSNumber *)value stringValue] URLEncode];
                        } else {
                                continue;
                        }
                        
                        [array addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
                }
        }
        
        if (array.count) {
                return [array componentsJoinedByString:@"&"];
        }
        return @"";
}

- (id)esObjectForKey:(id)key
{
        id object = self[key];
        if ([object isKindOfClass:[NSNull class]]) {
                object = nil;
        }
        return object;
}

- (void)each:(void (^)(id key, id obj, BOOL *stop))block
{
        [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)each:(void (^)(id key, id obj, BOOL *stop))block option:(NSEnumerationOptions)option
{
        [self enumerateKeysAndObjectsWithOptions:option usingBlock:block];
}

- (id)match:(BOOL (^)(id key, id obj))predicate
{
        NSParameterAssert(predicate);
        NSSet *set = [self matches:^BOOL(id key_, id obj_, BOOL *stop) {
                if (predicate(key_, obj_)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        }];
        return [set anyObject];
}

- (id)match:(BOOL (^)(id key, id obj))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSSet *set = [self matches:^BOOL(id key_, id obj_, BOOL *stop) {
                if (predicate(key_, obj_)) {
                        *stop = YES;
                        return YES;
                }
                return NO;
        } option:option];
        return [set anyObject];
}

- (NSDictionary *)matchDictionary:(BOOL (^)(id key, id obj))predicate
{
        id key = [self match:predicate];
        if (key) {
                return self[key];
        }
        return nil;
}

- (NSDictionary *)matchDictionary:(BOOL (^)(id key, id obj))predicate option:(NSEnumerationOptions)option
{
        id key = [self match:predicate option:option];
        if (key) {
                return self[key];
        }
        return nil;
}



- (NSSet *)matches:(BOOL (^)(id key, id obj, BOOL *stop))predicate
{
        return [self keysOfEntriesPassingTest:predicate];
}

- (NSSet *)matches:(BOOL (^)(id key, id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        return [self keysOfEntriesWithOptions:option passingTest:predicate];
}

- (NSDictionary *)matchesDictionary:(BOOL (^)(id key, id obj, BOOL *stop))predicate
{
        NSParameterAssert(predicate);
        NSSet *set = [self matches:predicate];
        NSArray *keys = [set allObjects];
        NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
        return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)matchesDictionary:(BOOL (^)(id key, id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSSet *set = [self matches:predicate option:option];
        NSArray *keys = [set allObjects];
        NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
        return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESWeakSelf;
        ESDispatchOnDefaultQueue(^{
                ESStrongSelf;
                BOOL result = NO;
                if (ESTouchDirectoryAtFilePath(path)) {
                        result = [_self writeToFile:path atomically:useAuxiliaryFile];
                }
                if (block) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                block(result);
                        });
                }
        });
}

@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSMutableDictionary
@implementation NSMutableDictionary (ESAdditions)

- (void)matchWith:(BOOL (^)(id key, id obj, BOOL *stop))predicate
{
        NSParameterAssert(predicate);
        NSArray *keys = [[self matches:predicate] allObjects];
        if (ESIsArrayWithItems(keys)) {
                [self removeObjectsForKeys:keys];
        }
}

- (void)matchWith:(BOOL (^)(id key, id obj, BOOL *stop))predicate option:(NSEnumerationOptions)option
{
        NSParameterAssert(predicate);
        NSArray *keys = [[self matches:predicate option:option] allObjects];
        if (ESIsArrayWithItems(keys)) {
                [self removeObjectsForKeys:keys];
        }
}

@end
