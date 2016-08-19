//
//  NSMutableString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESValue.h"
#import "NSString+ESAdditions.h"
#import "NSMutableString+ESAdditions.h"

@implementation NSMutableString (ESAdditions)

- (void)replace:(NSString *)string to:(NSString *)replacement options:(NSStringCompareOptions)options
{
    if (![string isKindOfClass:[NSString class]]) {
        return;
    }

    [self replaceOccurrencesOfString:string withString:replacement ?: @"" options:options range:NSMakeRange(0, self.length)];
}

- (void)replace:(NSString *)string to:(NSString *)replacement
{
    [self replace:string to:replacement options:0];
}

- (void)replaceCaseInsensitive:(NSString *)string to:(NSString *)replacement
{
    [self replace:string to:replacement options:NSCaseInsensitiveSearch];
}

- (void)replaceInRange:(NSRange)range to:(NSString *)replacement
{
    if (!replacement) {
        replacement = @"";
    }
    [self replaceCharactersInRange:range withString:replacement];
}

- (void)replaceRegex:(NSString *)pattern to:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive
{
    [self replace:pattern to:replacement options:(NSRegularExpressionSearch | (caseInsensitive ? NSCaseInsensitiveSearch : 0))];
}

- (void)replaceWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options
{
    for (id key in dictionary) {
        [self replace:ESStringValue(key) to:ESStringValue(dictionary[key]) options:options];
    }
}

@end
