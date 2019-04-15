//
//  NSString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESValue.h"
#import "NSString+ESAdditions.h"
#import "NSMutableString+ESAdditions.h"
#import "NSDictionary+ESAdditions.h"
#import "NSCharacterSet+ESAdditions.h"

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
    if (!replacement) {
        replacement = @"";
    }
    return [self stringByReplacingOccurrencesOfString:string withString:replacement options:options range:NSMakeRange(0, self.length)];
}

- (NSString *)stringByReplacingInRange:(NSRange)range with:(NSString *)replacement
{
    if (!replacement) {
        replacement = @"";
    }
    return [self stringByReplacingCharactersInRange:range withString:replacement];
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

- (NSArray *)splitWith:(NSString *)separator
{
    return [self componentsSeparatedByString:separator];
}

- (NSArray *)splitWithCharacterSet:(NSCharacterSet *)separator
{
    return [self componentsSeparatedByCharactersInSet:separator];
}

- (NSString *)URLEncode
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:
            [NSCharacterSet URLEncodingAllowedCharacterSet]];
}

- (NSString *)URLDecode
{
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByRemovingPercentEncoding];
}

- (NSDictionary *)queryDictionary
{
    /**
     * path=xxx
     * http://path.com/test/?key=value
     * tel:path?key=value
     * //path#key=value&array[]=val&array[]
     * path?key=value
     * /path/?key
     * path?key=value#fragment
     */
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSMutableString *queryString = self.mutableCopy;

    // 移除协议: http:// , file:/// , tel: , // .
    [queryString replaceRegex:@"^[^:/]*[:/]+" to:@"" caseInsensitive:NO];

    NSRange firstEqualRange = [queryString rangeOfString:@"="];
    if (firstEqualRange.location != NSNotFound) {
        // # 可能当作锚点： # 位于 ? 的后面，
        // # 也可能当作查询字符串的开始，例如 http://twitter.com/#!/username ,
        // https://www.google.com/#newwindow=1&q=url).
        NSRange fragmentStart = [queryString rangeOfString:@"#"];
        if (fragmentStart.location != NSNotFound &&
            fragmentStart.location > firstEqualRange.location) {
            // 如果 # 是锚点，则忽略（移除）锚点后面的所有字符串
            NSRange fragmentRange = NSMakeRange(fragmentStart.location, queryString.length - fragmentStart.location);
            [queryString deleteCharactersInRange:fragmentRange];
        }

        // 移除 /?# 结尾的 url.path
        [queryString replaceRegex:@"^[^?#]*[/?#]+" to:@"" caseInsensitive:NO];

        // 按 & 分割 query 字符串
        NSArray *parts = [queryString splitWith:@"&"];

        for (NSString *query in parts) {
            NSArray *keyValue = [query splitWith:@"="];
            if (keyValue.count != 2) {
                continue;
            }
            NSString *key = [ESStringValueWithDefault(keyValue[0], @"") URLDecode];
            NSString *value = [ESStringValueWithDefault(keyValue[1], @"") URLDecode];
            if (key.isEmpty || value.isEmpty) {
                continue;
            }
            if ([key hasSuffix:@"[]"]) {
                key = [key substringToIndex:key.length - 2];
                if (key.isEmpty) {
                    continue;
                }
                if (!result[key] || ![result[key] isKindOfClass:[NSMutableArray class]]) {
                    result[key] = [NSMutableArray array];
                }
                [(NSMutableArray *)(result[key]) addObject:value];
            } else {
                result[key] = value;
            }
        }
    }

    return [result copy];
}

- (NSString *)stringByAppendingQueryDictionary:(NSDictionary *)queryDictionary
{
    NSMutableString *result = self.mutableCopy;
    NSString *fragment = nil;
    NSString *queryString = queryDictionary.queryString;

    if (ESIsStringWithAnyText(queryString)) {
        // 临时保存fragment, 在拼接queryString后再拼接fragment
        NSRange fragmentStart = [result rangeOfString:@"#"];
        if (fragmentStart.location != NSNotFound) {
            fragment = [self substringFromIndex:fragmentStart.location];
            NSRange fragmentRange = NSMakeRange(fragmentStart.location, result.length - fragmentStart.location);
            [result deleteCharactersInRange:fragmentRange];
        }
        // 去掉原串末尾的?或&， 方面后面拼接时添加连接符
        if (result.length > 0) {
            NSString *lastChar = [result substringFromIndex:result.length - 1];
            if ([lastChar isEqualToString:@"?"] || [lastChar isEqualToString:@"&"]) {
                [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
            }
        }
        // 拼接
        [result appendFormat:@"%@%@", ([result contains:@"?"] ? @"&" : @"?"), queryString];
    }

    if (fragment) {
        [result appendString:fragment];
    }
    return [result copy];
}

- (NSString *)URLSafeBase64String
{
    static NSDictionary *replacement = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacement = @{ @"+": @"-",
                         @"/": @"_",
                         @"=": @"" };
    });

    return [self stringByReplacingWithDictionary:replacement options:0];
}

- (NSString *)base64StringFromURLSafeString
{
    static NSDictionary *replacement = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        replacement = @{ @"-": @"+",
                         @"_": @"/" };
    });

    NSMutableString *result = self.mutableCopy;
    [result replaceWithDictionary:replacement options:0];

    NSUInteger equalLength = result.length % 4;
    if (equalLength) {
        return [result stringByPaddingToLength:result.length + 4 - equalLength withString:@"=" startingAtIndex:0];
    }

    return [result copy];
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

- (NSRange)match:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive
{
    return [self rangeOfString:pattern options:(NSRegularExpressionSearch | (caseInsensitive ? NSCaseInsensitiveSearch : 0))];
}
- (NSRange)match:(NSString *)pattern
{
    return [self match:pattern caseInsensitive:NO];
}
- (BOOL)isMatch:(NSString *)pattern
{
    return [self isMatch:pattern caseInsensitive:NO];
}
- (BOOL)isMatch:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive
{
    return (NSNotFound != [self match:pattern caseInsensitive:caseInsensitive].location);
}

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc completion:(void (^)(BOOL result))completion
{
    es_dispatch_async_default(^{
        BOOL result = (ESTouchDirectoryAtFilePath(path) &&
                       [self writeToFile:path atomically:useAuxiliaryFile encoding:enc error:NULL]);
        if (completion) {
            es_dispatch_async_main(^{
                completion(result);
            });
        }
    });
}

- (void)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc completion:(void (^)(BOOL result))completion
{
    es_dispatch_async_default(^{
        BOOL result = (ESTouchDirectoryAtFileURL(url) &&
                       [self writeToURL:url atomically:useAuxiliaryFile encoding:enc error:NULL]);
        if (completion) {
            es_dispatch_async_main(^{
                completion(result);
            });
        }
    });
}

@end
