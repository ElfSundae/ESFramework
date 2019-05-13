//
//  NSDictionary+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDictionary+ESAdditions.h"
#import "NSURLComponents+ESAdditions.h"

@implementation NSDictionary (ESAdditions)

- (NSDictionary *)entriesForKeys:(NSSet *)keys
{
    NSMutableDictionary *entries = [NSMutableDictionary dictionary];
    for (id key in keys) {
        id value = self[key];
        if (value) {
            entries[key] = value;
        }
    }
    return entries.copy;
}

- (NSString *)URLQueryString
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"http://foo.bar"];
    urlComponents.queryItemsDictionary = self;
    return urlComponents.percentEncodedQuery;
}

- (NSDictionary *)entriesPassingTest:(BOOL (NS_NOESCAPE ^)(id, id, BOOL *))predicate
{
    return [self entriesWithOptions:0 passingTest:predicate];
}

- (NSDictionary *)entriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (NS_NOESCAPE ^)(id, id, BOOL *))predicate
{
    NSArray *keys = [self keysOfEntriesWithOptions:opts passingTest:predicate].allObjects;
    NSArray *objects = [self objectsForKeys:keys notFoundMarker:NSNull.null];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

@end

#pragma mark - NSMutableDictionary (ESAdditions)

@implementation NSMutableDictionary (ESAdditions)

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath
{
    NSMutableDictionary *dict = self;
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    for (NSUInteger i = 0; i + 1 < keys.count; i++) {
        NSString *key = keys[i];
        NSMutableDictionary *current = dict[key];

        if ([current isKindOfClass:NSDictionary.class] &&
            ![current isKindOfClass:NSMutableDictionary.class]) {
            current = current.mutableCopy;
        }

        if (!current || ![current isKindOfClass:NSMutableDictionary.class]) {
            current = [NSMutableDictionary dictionary];
        }

        dict[key] = current;
        dict = current;
    }

    dict[keys.lastObject] = object;
}

@end
