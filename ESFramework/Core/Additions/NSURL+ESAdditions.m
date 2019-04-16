//
//  NSURL+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSURL+ESAdditions.h"
#import "NSString+ESAdditions.h"

@implementation NSURL (ESAdditions)

- (BOOL)isEqualToURL:(NSURL *)anotherURL
{
    return [self.absoluteString isEqualToString:anotherURL.absoluteString];
}

- (NSDictionary<NSString *, id> *)queryComponents
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];

    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    for (NSURLQueryItem *item in urlComponents.queryItems) {
        if (!item.value) {
            continue;
        }

        if ([item.name hasSuffix:@"[]"]) { // array
            NSString *name = [item.name substringToIndex:item.name.length - 2];
            if (![result[name] isKindOfClass:[NSMutableArray class]]) {
                result[name] = [NSMutableArray array];
            }
            [(NSMutableArray *)(result[name]) addObject:item.value];
        } else {
            result[item.name] = item.value;
        }
    }

    return [result copy];
}

@end
