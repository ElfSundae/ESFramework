//
//  NSString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSString+ESAdditions.h"
#import "NSMutableString+ESAdditions.h"
#import "NSDictionary+ESAdditions.h"

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

- (NSString *)stringByAppendingQueryDictionary:(NSDictionary *)queryDictionary
{
        NSString *queryString = queryDictionary.queryString;
        if (ESIsStringWithAnyText(queryString)) {
                NSString *trimed = [self trimWithCharactersInString:@"?&"];
                return [trimed stringByAppendingFormat:@"%@%@", ([trimed contains:@"?"] ? @"&" : @"?"), queryString];
        }
        return self;
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
        return (NSString *)result;
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

static NSString *const kESCharactersToBeEscaped = @":/?#[]@!$&'()*+,;=";
- (NSString *)URLEncode
{
        CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)kESCharactersToBeEscaped, kCFStringEncodingUTF8);
        return CFBridgingRelease(encoded);
}

- (NSString *)URLDecode
{
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        return [decoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)queryDictionary
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];

        NSMutableString *queryString = self.mutableCopy;
        
        // remove Scheme
        [queryString replaceRegex:@"^[^:/]*:/*" to:@"" caseInsensitive:YES];
        
        // 搜索第一个 ?&# 的range
        NSRange searchFirstMarkInRange = NSMakeRange(0, queryString.length);
        // 在第一个"="前搜索, 因为query可能是一个不带"?"前缀的串,例如"test=xxx&abc=foo"，所以以等号来截取得到queryString
        NSRange firstEqual = [queryString rangeOfString:@"="];
        if (NSNotFound != firstEqual.location) {
                searchFirstMarkInRange = NSMakeRange(0, firstEqual.location);
        }
        
        // 搜索第一个 ?&#, 把这个mark之前的舍弃掉
        NSRange firstMarkRange = [queryString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?&#"]
                                                              options:0
                                                                range:searchFirstMarkInRange];
        // 去掉mark之前的字符串,得到queryString
        if (NSNotFound != firstMarkRange.location) {
                [queryString deleteCharactersInRange:NSMakeRange(0, firstMarkRange.location + 1)];
        }
        
        
        // 将queryString按 & 或者 # 分割
        NSArray *components = [queryString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&#"]];
        
        for (NSString *str in components) {
                NSArray *keyValue = [str componentsSeparatedByString:@"="];
                if (0 == keyValue.count) {
                        continue;
                }
                
                NSString *key = keyValue[0];
                NSString *value = keyValue.count > 1 ? [keyValue[1] URLDecode] : nil;
                
                if ([key hasSuffix:@"[]"]) { // array
                        key = [[key substringToIndex:key.length - 2] URLDecode];
                        if (![result[key] isKindOfClass:[NSMutableArray class]]) {
                                result[key] = [NSMutableArray array];
                        }
                        if (value) {
                                [(NSMutableArray *)(result[key]) addObject:value];
                        }
                } else {
                        key = [key URLDecode];
                        result[key] = value ?: [NSNull null];
                }
        }
        return (NSDictionary *)result;
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

//- (NSString *)stringByReplacingCamelcaseWith:(NSString *)replace
//{
//        NSString *string = [self stringByReplacingRegex:@"\\W" with:@"_" caseInsensitive:YES];
//        NSMutableString *result = [NSMutableString string];
//        for (NSUInteger i = 0; i < string.length; i++) {
//                NSString *aChar = [string substringWithRange:NSMakeRange(i, 1)];
//                if (![aChar isEqualToString:@"_"] && [aChar isEqualToString:[aChar uppercaseString]]) {
//                        if (i == 0) {
//                                [result appendString:[aChar lowercaseString]];
//                        } else {
//                                [result appendFormat:@"%@%@", replace, [aChar lowercaseString]];
//                        }
//                } else {
//                        [result appendString:[aChar lowercaseString]];
//                }
//        }
//        return result;
//}
//
//- (NSString *)stringByReplacingCamelcaseWithUnderscore
//{
//        return [self stringByReplacingCamelcaseWith:@"_"];
//}

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
        ESDispatchOnDefaultQueue(^{
                BOOL result = (ESTouchDirectoryAtFilePath(path) &&
                               [self writeToFile:path atomically:useAuxiliaryFile encoding:enc error:NULL]);
                ESDispatchOnMainThreadAsynchrony(^{
                        if (completion) {
                                completion(result);
                        }
                });
        });
}

- (void)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc completion:(void (^)(BOOL result))completion
{
       ESDispatchOnDefaultQueue(^{
               BOOL result = (ESTouchDirectoryAtURL(url) &&
                              [self writeToURL:url atomically:useAuxiliaryFile encoding:enc error:NULL]);
               ESDispatchOnMainThreadAsynchrony(^{
                       if (completion) {
                               completion(result);
                       }
               });
       });
}

@end
