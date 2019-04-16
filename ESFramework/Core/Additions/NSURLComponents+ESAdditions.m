//
//  NSURLComponents+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/16.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSURLComponents+ESAdditions.h"
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
    [self addQueryItem:[NSURLQueryItem queryItemWithName:name value:value]];
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
    NSArray *queryItems = self.queryItems;
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

- (void)setQueryItemsDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    if (!dictionary) {
        self.queryItems = nil;
        return;
    }

    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *name in dictionary) {
        id value = dictionary[name];

        if ([value isKindOfClass:NSArray.class]) {
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

@end
