//
//  NSString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSString+ESAdditions.h"
#import "ESDefines.h"
#import "ESValue.h"
#import "NSMutableString+ESAdditions.h"
#import "NSDictionary+ESAdditions.h"
#import "NSCharacterSet+ESAdditions.h"
#import "NSURL+ESAdditions.h"
#import "NSURLComponents+ESAdditions.h"

@implementation NSString (ESAdditions)

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString
{
    return (NSOrderedSame == [self caseInsensitiveCompare:aString]);
}

- (BOOL)isEmpty
{
    return (0 == self.length);
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimWithCharactersInString:(NSString *)string
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:string]];
}

- (BOOL)contains:(NSString *)string
{
    return [self contains:string options:0];
}

- (BOOL)containsCaseInsensitive:(NSString *)string
{
    return [self contains:string options:NSCaseInsensitiveSearch];
}

- (BOOL)contains:(NSString *)string options:(NSStringCompareOptions)options
{
    return (NSNotFound != [self rangeOfString:string options:options].location);
}

- (NSRange)match:(NSString *)pattern
{
    return [self match:pattern caseInsensitive:NO];
}

- (NSRange)match:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive
{
    return [self rangeOfString:pattern options:(NSRegularExpressionSearch | (caseInsensitive ? NSCaseInsensitiveSearch : 0))];
}

- (BOOL)isMatch:(NSString *)pattern
{
    return [self isMatch:pattern caseInsensitive:NO];
}

- (BOOL)isMatch:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive
{
    return (NSNotFound != [self match:pattern caseInsensitive:caseInsensitive].location);
}

- (NSString *)stringByReplacing:(NSString *)string with:(NSString *)replacement
{
    return [self stringByReplacing:string with:replacement options:0];
}

- (NSString *)stringByReplacingCaseInsensitive:(NSString *)string with:(NSString *)replacement
{
    return [self stringByReplacing:string with:replacement options:NSCaseInsensitiveSearch];
}

- (NSString *)stringByReplacing:(NSString *)string with:(NSString *)replacement options:(NSStringCompareOptions)options
{
    return [self stringByReplacingOccurrencesOfString:string withString:replacement ?: @"" options:options range:NSMakeRange(0, self.length)];
}

- (NSString *)stringByReplacingInRange:(NSRange)range with:(NSString *)replacement
{
    return [self stringByReplacingCharactersInRange:range withString:replacement ?: @""];
}

- (NSString *)stringByReplacingWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options
{
    NSMutableString *result = self.mutableCopy;
    [result replaceWithDictionary:dictionary options:options];
    return [result copy];
}

- (NSString *)stringByReplacingRegex:(NSString *)pattern with:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive
{
    return [self stringByReplacing:pattern with:replacement options:(NSRegularExpressionSearch | (caseInsensitive ? NSCaseInsensitiveSearch : 0))];
}

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characters
{
    return [[self componentsSeparatedByCharactersInSet:characters] componentsJoinedByString:@""];
}

- (NSString *)stringByDeletingCharactersInString:(NSString *)string
{
    return [self stringByDeletingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:string]];
}

- (NSArray<NSString *> *)splitWith:(NSString *)separator
{
    return [self componentsSeparatedByString:separator];
}

- (NSArray<NSString *> *)splitWithCharacterSet:(NSCharacterSet *)separator
{
    return [self componentsSeparatedByCharactersInSet:separator];
}

- (NSString *)URLEncoded
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:
            [NSCharacterSet URLEncodingAllowedCharacterSet]];
}

- (NSString *)URLDecoded
{
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByRemovingPercentEncoding];
}

- (NSDictionary<NSString *, id> *)queryDictionary
{
    return [NSURLComponents componentsWithString:self].queryItemsDictionary;
}

- (NSString *)stringByAddingQueryDictionary:(NSDictionary<NSString *, id> *)queryDictionary
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:self];
    [urlComponents addQueryItemsDictionary:queryDictionary];
    return urlComponents.string;
}

- (NSString *)stringByEncodingHTMLEntitiesUsingTable:(ESHTMLEscapeMap *)table size:(NSUInteger)size escapeUnicode:(BOOL)escapeUnicode
{
    return [self es_gtm_stringByEscapingHTMLUsingTable:table
                                                ofSize:size
                                       escapingUnicode:escapeUnicode];
}

- (NSString *)stringByEncodingHTMLEntitiesForUnicode
{
    return [self es_gtm_stringByEscapingForHTML];
}

- (NSString *)stringByEncodingHTMLEntitiesForASCII
{
    return [self es_gtm_stringByEscapingForAsciiHTML];
}

- (NSString *)stringByDecodingHTMLEntities
{
    NSString *result = [self es_gtm_stringByUnescapingFromHTML];
    if (result) {
        return [NSString stringWithString:result];
    }
    return nil;
}

@end
