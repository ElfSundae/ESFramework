//
//  NSURL+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSURL+ESAdditions.h"
#import "NSURLComponents+ESAdditions.h"

@implementation NSURL (ESAdditions)

- (BOOL)isEqualToURL:(NSURL *)anotherURL
{
    return ([self isEqual:anotherURL] || [self.absoluteString isEqualToString:anotherURL.absoluteString]);
}

- (NSDictionary<NSString *, id> *)queryDictionary
{
    return [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES].queryItemsDictionary;
}

- (NSURL *)URLByAddingQueryDictionary:(NSDictionary<NSString *, id> *)queryDictionary
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    [urlComponents addQueryItemsDictionary:queryDictionary];
    return urlComponents.URL;
}


@end
