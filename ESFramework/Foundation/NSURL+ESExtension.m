//
//  NSURL+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSURL+ESExtension.h"
#import "NSURLComponents+ESExtension.h"

@implementation NSURL (ESExtension)

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
