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
    self.queryItems = [(self.queryItems ?: @[]) arrayByAddingObjectsFromArray:queryItems];
}

- (void)addQueryItem:(NSURLQueryItem *)item
{
    self.queryItems = [(self.queryItems ?: @[]) arrayByAddingObject:item];
}

- (void)addQueryItemWithName:(NSString *)name value:(NSString *)value
{
    [self addQueryItem:[NSURLQueryItem queryItemWithName:name value:value]];
}

- (NSDictionary<NSString *,id> *)queryItemsDictionary
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
            if (![result[name] isKindOfClass:[NSMutableArray class]]) {
                result[name] = @[result[name]].mutableCopy;
            }
            [(NSMutableArray *)result[name] addObject:item.value];
        } else {
            result[name] = item.value;
        }
    }
    return [result copy];
}

- (void)setQueryItemsDictionary:(NSDictionary<NSString *,id> *)dictionary
{
    if (!dictionary) {
        self.queryItems = nil;
        return;
    }

    NSMutableArray *queryItems = [NSMutableArray array];
    for (NSString *name in dictionary) {
        if ([dictionary[name] isKindOfClass:[NSArray class]]) {
            NSString *itemName = [name stringByAppendingString:@"[]"];
            for (id value in (NSArray *)dictionary[name]) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:itemName value:ESStringValue(value)]];
            }
        } else {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:name value:ESStringValue(dictionary[name])]];
        }
    }
    self.queryItems = [queryItems copy];
}

@end
