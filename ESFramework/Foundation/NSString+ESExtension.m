//
//  NSString+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSString+ESExtension.h"
#import "ESHelpers.h"
#import "NSNumber+ESExtension.h"
#import "NSCharacterSet+ESExtension.h"
#import "NSURLComponents+ESExtension.h"

@implementation NSString (ESExtension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ESSwizzleInstanceMethod(self, @selector(doubleValue), @selector(es_doubleValue));
        ESSwizzleInstanceMethod(self, @selector(floatValue), @selector(es_floatValue));
        ESSwizzleInstanceMethod(self, @selector(intValue), @selector(es_intValue));
        ESSwizzleInstanceMethod(self, @selector(integerValue), @selector(es_integerValue));
        ESSwizzleInstanceMethod(self, @selector(longLongValue), @selector(es_longLongValue));
        ESSwizzleInstanceMethod(self, @selector(boolValue), @selector(es_boolValue));
    });
}

- (double)es_doubleValue
{
    return self.numberValue.doubleValue;
}

- (float)es_floatValue
{
    return self.numberValue.floatValue;
}

- (int)es_intValue
{
    return self.numberValue.intValue;
}

- (NSInteger)es_integerValue
{
    return self.numberValue.integerValue;
}

- (long long)es_longLongValue
{
    return self.numberValue.longLongValue;
}

- (BOOL)es_boolValue
{
    return self.numberValue.boolValue;
}

+ (NSString *)UUIDString
{
    return [NSUUID UUID].UUIDString;
}

+ (nullable NSString *)randomStringWithLength:(NSUInteger)length
{
    static char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    static uint32_t charsetLen = (uint32_t)(sizeof(charset) - 1);

    char *str = malloc(length + 1);
    if (!str) {
        return nil;
    }

    for (NSUInteger i = 0; i < length; i++) {
        str[i] = charset[arc4random_uniform(charsetLen)];
    }
    str[length] = '\0';
    
    return [NSString stringWithUTF8String:str];
}

- (NSNumber *)numberValue
{
    return [NSNumber numberWithString:self];
}

- (char)charValue
{
    return self.numberValue.charValue;
}

- (unsigned char)unsignedCharValue
{
    return self.numberValue.unsignedCharValue;
}

- (short)shortValue
{
    return self.numberValue.shortValue;
}

- (unsigned short)unsignedShortValue
{
    return self.numberValue.unsignedShortValue;
}

- (unsigned int)unsignedIntValue
{
    return self.numberValue.unsignedIntValue;
}

- (long)longValue
{
    return self.numberValue.longValue;
}

- (unsigned long)unsignedLongValue
{
    return self.numberValue.unsignedLongValue;
}

- (unsigned long long)unsignedLongLongValue
{
    return self.numberValue.unsignedLongLongValue;
}

- (NSUInteger)unsignedIntegerValue
{
    return self.numberValue.unsignedIntegerValue;
}

- (nullable NSData *)dataValue
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)trimmedString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)URLEncodedString
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLEncodingAllowedCharacterSet]];
}

- (NSString *)URLDecodedString
{
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByRemovingPercentEncoding];
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
    NSMutableString *result = [self mutableCopy];
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

@end

@implementation NSMutableString (ESExtension)

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options
{
    return [self replaceOccurrencesOfString:target withString:replacement options:options range:NSMakeRange(0, self.length)];
}

- (void)replaceWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary options:(NSStringCompareOptions)options
{
    for (NSString *key in dictionary) {
        [self replaceOccurrencesOfString:key withString:dictionary[key] options:options];
    }
}

@end
