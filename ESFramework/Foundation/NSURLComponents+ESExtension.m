//
//  NSURLComponents+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/16.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "NSURLComponents+ESExtension.h"
#import "ESHelpers.h"

@implementation NSURLComponents (ESExtension)

- (void)addQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    NSArray *oldItems = self.queryItems;
    self.queryItems = oldItems ? [oldItems arrayByAddingObjectsFromArray:queryItems] : queryItems;
}

- (void)addQueryItem:(NSURLQueryItem *)item
{
    [self addQueryItems:@[ item ]];
}

- (void)addQueryItemWithName:(NSString *)name value:(NSString *)value
{
    if ((name = ESStringValue(name))) {
        [self addQueryItem:[NSURLQueryItem queryItemWithName:name value:ESStringValue(value)]];
    }
}

- (void)removeQueryItemsWithNames:(NSArray<NSString *> *)names
{
    NSArray *queryItems = self.queryItems;
    if (queryItems) {
        NSMutableArray *predicates = [NSMutableArray array];
        for (NSString *name in names) {
            [predicates addObject:[NSPredicate predicateWithFormat:@"name != %@ AND name != %@",
                                   name, [name stringByAppendingString:@"[]"]]];
        }
        NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
        queryItems = [queryItems filteredArrayUsingPredicate:compoundPredicate];

        self.queryItems = queryItems.count > 0 ? queryItems : nil;
    }
}

- (void)removeQueryItemsWithName:(NSString *)name
{
    [self removeQueryItemsWithNames:@[ name ]];
}

- (NSDictionary<NSString *, id> *)queryParameters
{
    NSArray<NSURLQueryItem *> *queryItems = self.queryItems;

    if (!queryItems) {
        return nil;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    for (NSURLQueryItem *item in queryItems) {
        NSString *name = item.name;
        if ([name hasSuffix:@"[]"]) {
            name = [name substringToIndex:name.length - 2];
        }
        if (!name.length) {
            continue;
        }

        id value = item.value ?: [NSNull null];

        if (parameters[name]) {
            NSMutableArray *arr = parameters[name];
            if (![arr isKindOfClass:[NSMutableArray class]]) {
                arr = [NSMutableArray arrayWithObject:arr];
                parameters[name] = arr;
            }
            [arr addObject:value];
        } else {
            parameters[name] = value;
        }
    }

    return [parameters copy];
}

- (void)setQueryParameters:(NSDictionary<NSString *, id> *)parameters
{
    if (!parameters) {
        self.queryItems = nil;
        return;
    }

    NSMutableArray *queryItems = [NSMutableArray array];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES];
    NSArray *sortedKeys = [parameters.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]];

    for (NSString *key in sortedKeys) {
        NSString *name = ESStringValue(key);
        if (!name || !name.length) {
            continue;
        }

        id value = parameters[key];

        if ([value isKindOfClass:[NSArray class]]) {
            NSString *itemName = [name stringByAppendingString:@"[]"];
            for (id itemValue in (NSArray *)value) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:itemName value:ESStringValue(itemValue)]];
            }
        } else {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:name value:ESStringValue(value)]];
        }
    }

    self.queryItems = queryItems;
}

- (void)addQueryParameters:(NSDictionary<NSString *, id> *)parameters
{
    if (!parameters.count) {
        return;
    }

    NSMutableDictionary *dict = (self.queryParameters ?: @{}).mutableCopy;
    [dict addEntriesFromDictionary:parameters];
    self.queryParameters = dict;
}

@end
