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
