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

- (NSURLComponents *)components
{
    return [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
}

- (BOOL)isEqualToURL:(NSURL *)anotherURL
{
    return [self.absoluteString isEqualToString:anotherURL.absoluteString];
}

- (NSDictionary<NSString *, id> *)queryDictionary
{
    return self.components.queryItemsDictionary;
}

@end
