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
#import "GTMNSString+HTML.h"

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

- (NSString *)trim
{
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
        ESWeak(self, weakSelf);
        ESDispatchOnDefaultQueue(^{
                ESStrong(weakSelf, _self);
                NSString *filePath = ESTouchFilePath(path);
                if (!filePath) {
                        if (block) {
                                block(NO);
                        }
                        return;
                }
                
                BOOL res = [self writeToFile:filePath atomically:useAuxiliaryFile encoding:NSUTF8StringEncoding error:NULL];
                if (block) {
                        block(res);
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
        return [self stringByAppendingQueryDictionary:queryDictionary];
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

- (NSString *)replaceWithDictionary:(NSDictionary *)dictionary withOptions:(NSStringCompareOptions)options
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

+ (NSString *)newUUID
{
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFBridgingRelease(theUUID);
        return CFBridgingRelease(string);
}

+ (NSString *)newUUIDWithMD5
{
        NSString *uuid = [self newUUID];
        return [uuid md5Hash];
}

- (NSString *)iTunesItemID
{
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"://itunes.apple.com/.*/id(\\d{8,})\\D" options:NSRegularExpressionCaseInsensitive error:NULL];
        NSTextCheckingResult *match = [reg firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        if (match) {
                return [self substringWithRange:[match rangeAtIndex:1]];
        }
        return nil;
}

- (BOOL)_es_isITunesItemID
{
        return ([self rangeOfString:@"^\\d{8,}$" options:NSRegularExpressionSearch].location != NSNotFound);
}

- (NSString *)appLink
{
        if ([self _es_isITunesItemID]) {
                return [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self];
        }
        return nil;
}

- (NSString *)appLinkForAppStore
{
        if ([self _es_isITunesItemID]) {
                return [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", self];
        }
        return nil;
}

- (NSString *)appReviewLinkForAppStore
{
        if ([self _es_isITunesItemID]) {
                return [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", self];
        }
        return nil;
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

- (NSString *)stringByAppendingQueryDictionary:(NSDictionary *)queryDictionary
{
        NSMutableString *result = [NSMutableString stringWithString:@""];
        if (self) {
                [result appendString:self];
        }
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSString *key in [queryDictionary keyEnumerator]) {
                id value = queryDictionary[key];
                if ([value isKindOfClass:[NSArray class]]) {
                        [(NSArray *)value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                [array addObject:[NSString stringWithFormat:@"%@[]=%@", key, [(NSString *)obj URLEncode]]];
                        }];
                } else {
                        NSString *valueString = nil;
                        if ([value isKindOfClass:[NSString class]]) {
                                valueString = (NSString *)value;
                        } else if ([value isKindOfClass:[NSNumber class]]) {
                                valueString = [(NSNumber *)value stringValue];
                        }
                        if (valueString) {
                                [array addObject:[NSString stringWithFormat:@"%@=%@", key, [valueString URLEncode]]];
                        }
                }
        }
        
        if (array.count) {
                NSString *params = [array componentsJoinedByString:@"&"];
                if ([result contains:@"?"]) {
                        [result appendFormat:@"&%@", params];
                } else {
                        [result appendFormat:@"?%@", params];
                }
        }

        return result;
}

- (NSDictionary *)queryDictionary
{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        NSRange firstMarkRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"?&#"]];
        if (firstMarkRange.location == NSNotFound) {
                return result;
        }
        NSString *subString = [self substringFromIndex:firstMarkRange.location+1];
        NSArray *components = [subString componentsSeparatedByString:@"&"];
        for (NSString *str in components) {
                NSArray *keyValue = [str componentsSeparatedByString:@"="];
                NSString *key = nil;
                NSString *value = nil;
                const NSUInteger count = keyValue.count;
                if (count == 1 || count == 2) {
                        key = [(NSString *)keyValue[0] URLDecode];
                        if (2 == count) {
                                value = [(NSString *)keyValue[1] URLDecode];
                        }
                }
                if (key) {
                        result[key] = (value ?: [NSNull null]);
                }
        }
        return (NSDictionary *)result;
}

- (NSString *)stringByEncodingHTMLEntitiesUsingTable:(ESHTMLEscapeMap *)table escapeUnicode:(BOOL)escapeUnicode
{
        return [self es_gtm_stringByEscapingHTMLUsingTable:table
                                                    ofSize:sizeof(table)
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

@end
