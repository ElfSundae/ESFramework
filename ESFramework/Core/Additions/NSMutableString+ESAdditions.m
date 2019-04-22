//
//  NSMutableString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSString+ESAdditions.h"

@implementation NSMutableString (ESAdditions)

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options
{
    return [self replaceOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(0, self.length)];
}

- (void)replaceWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary options:(NSStringCompareOptions)options
{
    for (NSString *key in dictionary) {
        [self replaceOccurrencesOfString:key withString:dictionary[key] options:options];
    }
}

@end
