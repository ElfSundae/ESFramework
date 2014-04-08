//
//  NSString+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "NSString+ESAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ESAdditions)

- (BOOL)containsString:(NSString*)string
{
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options
{
        return (NSNotFound != [self rangeOfString:string options:options].location);
}

- (NSString *)md5Hash
{
        const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

- (NSString *)md5HashWithUppercase
{
        return [[self md5Hash] uppercaseString];
}

static NSString *const kESCharactersToBeEscaped = @":/?#[]@!$&'()*+,;=";
- (NSString *)URLEncode
{
        CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)kESCharactersToBeEscaped, kCFStringEncodingUTF8);
        return [NSString stringWithString:(__bridge_transfer NSString *)encoded];
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

@end
