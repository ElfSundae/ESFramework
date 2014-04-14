//
//  NSString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "NSString+ESAdditions.h"

@implementation NSString (ESAdditions)

- (BOOL)containsString:(NSString*)string
{
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options
{
        return (NSNotFound != [self rangeOfString:string options:options].location);
}

- (NSString *)trim
{
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (NSString *)newUUID
{
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFBridgingRelease(theUUID);
        return CFBridgingRelease(string);
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
                if ([result containsString:@"?"]) {
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
        return result;
}

@end
