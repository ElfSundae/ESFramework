//
//  NSRegularExpression+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSRegularExpression+ESAdditions.h"

@implementation NSRegularExpression (ESAdditions)

+ (instancetype)regex:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError **)error
{
        return [self regularExpressionWithPattern:pattern options:options error:error];
}

+ (instancetype)regex:(NSString *)pattern options:(NSRegularExpressionOptions)options
{
        return [self regex:pattern options:options error:NULL];
}

+ (instancetype)regex:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive
{
        return [self regex:pattern options:(caseInsensitive ? NSRegularExpressionCaseInsensitive : 0) error:NULL];
}

- (NSArray *)matchesInString:(NSString *)string
{
        return [self matchesInString:string options:0 range:NSMakeRange(0, string.length)];
}
- (NSUInteger)numberOfMatchesInString:(NSString *)string
{
        return [self numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
}
- (NSTextCheckingResult *)firstMatchInString:(NSString *)string
{
        return [self firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
}
- (NSRange)rangeOfFirstMatchInString:(NSString *)string
{
        return [self rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
}

- (BOOL)isMatchInString:(NSString *)string
{
        return ([self numberOfMatchesInString:string] > 0);
}


- (NSString *)stringByReplacingMatchesInString:(NSString *)string withTemplate:(NSString *)templ
{
        return [self stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:templ];
}

- (NSUInteger)replaceMatchesInString:(NSMutableString *)string withTemplate:(NSString *)templ
{
        return [self replaceMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:templ];
}

@end
