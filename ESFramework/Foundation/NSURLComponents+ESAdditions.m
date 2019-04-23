//
//  NSURLComponents+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/16.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSURLComponents+ESAdditions.h"
#import "ESHelpers.h"
#import "ESValue.h"

@implementation NSURLComponents (ESAdditions)

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

- (NSDictionary<NSString *, id> *)queryItemsDictionary
{
    return [self _dictionaryFromQueryItems:self.queryItems];
}

- (void)setQueryItemsDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    self.queryItems = [self _queryItemsFromDictionary:dictionary];
}

- (void)addQueryItemsDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    NSMutableDictionary *dict = (self.queryItemsDictionary ?: @{}).mutableCopy;
    [dict addEntriesFromDictionary:dictionary];
    self.queryItemsDictionary = dict;
}

- (NSDictionary<NSString *, id> *)_dictionaryFromQueryItems:(NSArray<NSURLQueryItem *> *)queryItems
{
    if (!queryItems) {
        return nil;
    }

    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in queryItems) {
        if (!item.value) {
            continue;
        }

        NSString *name = item.name;
        if ([name hasSuffix:@"[]"]) {
            name = [name substringToIndex:name.length - 2];
        }

        if (name.length == 0) {
            continue;
        }

        if (result[name]) {
            if (![result[name] isKindOfClass:NSMutableArray.class]) {
                result[name] = @[ result[name] ].mutableCopy;
            }
            [(NSMutableArray *)result[name] addObject:item.value];
        } else {
            result[name] = item.value;
        }
    }
    return [result copy];
}

- (NSArray<NSURLQueryItem *> *)_queryItemsFromDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    if (!dictionary) {
        return nil;
    }

    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *_name in dictionary) {
        NSString *name = ESStringValue(_name);
        if (!ESIsStringWithAnyText(name)) {
            continue;
        }

        id value = dictionary[_name];

        if ([value isKindOfClass:NSArray.class]) {
            NSString *itemName = [name stringByAppendingString:@"[]"];
            for (id itemValue in (NSArray *)value) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:itemName value:ESStringValue(itemValue)]];
            }
        } else {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:name value:ESStringValue(value)]];
        }
    }
    return [queryItems copy];
}

@end
