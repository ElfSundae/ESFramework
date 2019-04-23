//
//  NSString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSString+ESAdditions.h"
#import "NSCharacterSet+ESAdditions.h"
#import "NSURLComponents+ESAdditions.h"
#import "NSString+ESGTMHTML.h"

@implementation NSString (ESAdditions)

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString
{
    return (NSOrderedSame == [self caseInsensitiveCompare:aString]);
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options
{
    return [self stringByReplacingOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(0, self.length)];
}

- (NSString *)stringByReplacingWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options
{
    NSMutableString *result = self.mutableCopy;
    [result replaceWithDictionary:dictionary options:options];
    return [result copy];
}

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characters
{
    return [[self componentsSeparatedByCharactersInSet:characters] componentsJoinedByString:@""];
}

- (NSString *)stringByDeletingCharactersInString:(NSString *)string
{
    return [self stringByDeletingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:string]];
}

- (NSString *)URLEncoded
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLEncodingAllowedCharacterSet]];
}

- (NSString *)URLDecoded
{
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByRemovingPercentEncoding];
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

- (NSString *)stringByEncodingHTMLEntities
{
    return [self es_gtm_stringByEscapingForHTML];
}

- (NSString *)stringByDecodingHTMLEntities
{
    return [self es_gtm_stringByUnescapingFromHTML];
}

@end
