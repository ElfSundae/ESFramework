//
//  NSString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSString+ESAdditions.h"
#import "ESDefines.h"
#import "ESHash.h"
#import "NSDictionary+ESAdditions.h"

ES_CATEGORY_FIX(NSString_ESAdditions)

@implementation NSString (ESAdditions)

- (BOOL)contains:(NSString *)string
{
        return [self contains:string options:0];
}

- (BOOL)containsStringCaseInsensitive:(NSString *)string
{
        return [self contains:string options:NSCaseInsensitiveSearch];
}

- (BOOL)contains:(NSString *)string options:(NSStringCompareOptions)options
{
        return (NSNotFound != [self rangeOfString:string options:options].location);
}

- (BOOL)isEqualToStringCaseInsensitive:(NSString *)aString
{
        return (NSOrderedSame == [self caseInsensitiveCompare:aString]);
}

- (NSString *)trim
{
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimWithCharactersInString:(NSString *)string
{
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:string]];
}

- (BOOL)isEmpty
{
        return [self isEqualToString:@""];
}

- (BOOL)fileExists
{
        return [[NSFileManager defaultManager] fileExistsAtPath:self];
}

- (BOOL)fileExists:(BOOL *)isDirectory
{
        return [[NSFileManager defaultManager] fileExistsAtPath:self isDirectory:isDirectory];
}


- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESWeakSelf;
        ESDispatchOnDefaultQueue(^{
                ESStrongSelf;
                BOOL result = NO;
                if (ESTouchDirectoryAtFilePath(path)) {
                        result = [_self writeToFile:path atomically:useAuxiliaryFile encoding:NSUTF8StringEncoding error:NULL];
                }
                if (block) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                block(result);
                        });
                }
        });
}

- (NSString *)append:(NSString *)format, ...
{
        NSString *str = @"";
        if (format) {
                va_list args;
                va_start(args, format);
                str = [[NSString alloc] initWithFormat:format arguments:args];
                va_end(args);
        }
        return [self stringByAppendingString:str];
}

- (NSString *)appendPathComponent:(NSString *)format, ...
{
        NSString *str = @"";
        if (format) {
                va_list args;
                va_start(args, format);
                str = [[NSString alloc] initWithFormat:format arguments:args];
                va_end(args);
        }
        return [self stringByAppendingPathComponent:str];
}

- (NSString *)appendPathExtension:(NSString *)extension
{
        return [self stringByAppendingPathExtension:extension];
}

- (NSString *)appendQueryDictionary:(NSDictionary *)queryDictionary
{
        NSString *queryString = queryDictionary.queryString;
        if (!ESIsStringWithAnyText(queryString)) {
                return self;
        }
        
        NSString *trimed = [self trimWithCharactersInString:@"?&"];
        if ([self contains:@"?"]) {
                return [trimed append:@"&%@", queryString];
        } else {
                return [trimed append:@"?%@", queryString];
        }
}

- (NSString *)replace:(NSString *)string with:(NSString *)replacement
{
        return [self replace:string with:replacement options:0];
}
- (NSString *)replaceCaseInsensitive:(NSString *)string with:(NSString *)replacement
{
        return [self replace:string with:replacement options:NSCaseInsensitiveSearch];
}

- (NSString *)replace:(NSString *)string with:(NSString *)replacement options:(NSStringCompareOptions)options
{
        if (!replacement) {
                replacement = @"";
        }
        return [self stringByReplacingOccurrencesOfString:string withString:replacement options:options range:NSMakeRange(0, self.length)];
}
- (NSString *)replaceInRange:(NSRange)range with:(NSString *)replacement
{
        if (!replacement) {
                replacement = @"";
        }
        return [self stringByReplacingCharactersInRange:range withString:replacement];
}

- (NSString *)stringByReplacingWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options
{
        NSMutableString *result = [NSMutableString stringWithString:self];
        if (result.length > 0) {
                [result replaceWithDictionary:dictionary options:options];
        }
        return (NSString *)result;
}

- (NSString *)replaceRegex:(NSString *)pattern with:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive
{
        return [self replace:pattern with:replacement options:(NSRegularExpressionSearch | (caseInsensitive ? NSCaseInsensitiveSearch : 0))];
}

- (NSArray *)splitWith:(NSString *)separator
{
        return [self componentsSeparatedByString:separator];
}
- (NSArray *)splitWithCharacterSet:(NSCharacterSet *)separator
{
        return [self componentsSeparatedByCharactersInSet:separator];
}

- (NSString *)stringByDeletingCharactersInSet:(NSCharacterSet *)characters
{
        return [[self componentsSeparatedByCharactersInSet:characters] componentsJoinedByString:@""];
}

- (NSString *)stringByDeletingCharactersInString:(NSString *)string
{
        return [self stringByDeletingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:string]];
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

        // 搜索第一个 ?&# 的range
        NSRange searchFirstMarkInRange;
        // 在第一个"="前搜索, 因为self是一个不带"?"前缀的串,例如"test=xxx&abc=foo"
        NSRange firstEqual = [self rangeOfString:@"="];
        if (NSNotFound == firstEqual.location) {
                searchFirstMarkInRange = NSMakeRange(0, self.length);
        } else {
                searchFirstMarkInRange = NSMakeRange(0, firstEqual.location);
        }
        // 搜索第一个 ?&#, 把这个mark之前的舍弃掉
        NSRange firstMarkRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?&#"]
                                                       options:0
                                                         range:searchFirstMarkInRange];
        // 去掉mark之前的字符串,得到queryString
        NSString *string = nil;
        if (firstMarkRange.location == NSNotFound) {
                string = self;
        } else {
                string = [self substringFromIndex:firstMarkRange.location + 1];
        }
        // 将queryString按 & 分割
        NSArray *components = [string componentsSeparatedByString:@"&"];
        
        for (NSString *str in components) {
                NSArray *keyValue = [str componentsSeparatedByString:@"="];
                const NSUInteger count = keyValue.count;
                if (0 == count) {
                        continue;
                }
                
                NSString *key = keyValue[0];
                NSString *value = count > 1 ? [keyValue[1] URLDecode] : nil;
                
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

- (NSString *)stringByReplacingCamelcaseWith:(NSString *)replace
{
        NSString *string = [self replaceRegex:@"\\W" with:@"_" caseInsensitive:YES];
        NSMutableString *result = [NSMutableString string];
        for (NSUInteger i = 0; i < string.length; i++) {
                NSString *aChar = [string substringWithRange:NSMakeRange(i, 1)];
                if (![aChar isEqualToString:@"_"] && [aChar isEqualToString:[aChar uppercaseString]]) {
                        if (i == 0) {
                                [result appendString:[aChar lowercaseString]];
                        } else {
                                [result appendFormat:@"%@%@", replace, [aChar lowercaseString]];
                        }
                } else {
                        [result appendString:[aChar lowercaseString]];
                }
        }
        return result;
}

- (NSString *)stringByReplacingCamelcaseWithUnderscore
{
        return [self stringByReplacingCamelcaseWith:@"_"];
}

- (NSRegularExpression *)regexWithOptions:(NSRegularExpressionOptions)options
{
        return [NSRegularExpression regex:self options:options];
}
- (NSRegularExpression *)regex
{
        return [self regexWithOptions:0];
}
- (NSRegularExpression *)regexCaseInsensitive
{
        return [self regexWithOptions:NSRegularExpressionCaseInsensitive];
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

@end
