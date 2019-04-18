//
//  NSDictionary+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSDictionary+ESAdditions.h"
#import "NSURLComponents+ESAdditions.h"
#import "ESDefines.h"
#import "ESValue.h"
#import "NSString+ESAdditions.h"

@implementation NSDictionary (ESAdditions)

- (BOOL)isEmpty
{
    return (0 == self.count);
}

- (NSString *)URLQueryString
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:@"http://foo.bar"];
    urlComponents.queryItemsDictionary = self;
    return urlComponents.percentEncodedQuery;
}

- (NSDictionary *)entriesPassingTest:(BOOL (^)(id, id, BOOL *))predicate
{
    return [self entriesWithOptions:0 passingTest:predicate];
}

- (NSDictionary *)entriesWithOptions:(NSEnumerationOptions)opts passingTest:(BOOL (^)(id, id, BOOL *))predicate
{
    NSArray *keys = [self keysOfEntriesWithOptions:opts passingTest:predicate].allObjects;
    NSArray *objects = [self objectsForKeys:keys notFoundMarker:NSNull.null];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

@end

@implementation NSMutableDictionary (ESAdditions)

- (BOOL)es_setValue:(id)value forKeyPath:(NSString *)keyPath
{
    if (![keyPath isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (![keyPath contains:@"."]) {
        self[keyPath] = value;
        return YES;
    }
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    if (keys.count < 2) {
        return NO;
    }

    NSUInteger maxIndex = keys.count - 1;
    __block NSMutableString *currentKeyPath = [NSMutableString string];
    __block NSMutableDictionary *mutableCopy = self.mutableCopy;
    [keys enumerateObjectsUsingBlock:^(id subKey, NSUInteger idx, BOOL *stop) {
        [currentKeyPath appendFormat:@"%@%@", (currentKeyPath.length > 0 ? @"." : @""), subKey];
        if (idx == maxIndex) {
            [mutableCopy setValue:value forKeyPath:currentKeyPath];
            return;
        }
        id currentValue = [mutableCopy valueForKeyPath:currentKeyPath];
        if (!currentValue) {
            [mutableCopy setValue:[NSMutableDictionary dictionary] forKeyPath:currentKeyPath];
        } else if ([currentValue isKindOfClass:[NSDictionary class]] &&
                   ![currentValue isKindOfClass:[NSMutableDictionary class]])
        {
            [mutableCopy setValue:[currentValue mutableCopy] forKeyPath:currentKeyPath];
        } else if (![currentValue isKindOfClass:[NSDictionary class]]) {
            mutableCopy = nil;
            *stop = YES;
        }
    }];
    if (mutableCopy) {
        [self setDictionary:[mutableCopy copy]];
        return YES;
    }
    return NO;
}

@end
