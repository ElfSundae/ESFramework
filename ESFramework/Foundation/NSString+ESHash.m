//
//  NSString+ESHash.m
//  ESFramework
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSString+ESHash.h"
#import "NSData+ESHash.h"

@implementation NSString (ESHash)

- (NSData *)md5HashData
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5HashData];
}

- (NSString *)md5HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5HashString];
}

- (NSData *)sha1HashData
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1HashData];
}

- (NSString *)sha1HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1HashString];
}

- (NSData *)sha224HashData
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224HashData];
}

- (NSString *)sha224HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha224HashString];
}

- (NSData *)sha256HashData
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256HashData];
}

- (NSString *)sha256HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha256HashString];
}

- (NSData *)sha384HashData
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384HashData];
}

- (NSString *)sha384HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha384HashString];
}

- (NSData *)sha512HashData
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512HashData];
}

- (NSString *)sha512HashString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha512HashString];
}

- (NSData *)hmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacHashDataWithAlgorithm:algorithm key:key];
}

- (NSString *)hmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] hmacHashStringWithAlgorithm:algorithm key:key];
}

- (NSData *)base64EncodedData
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedData];
}

- (NSString *)base64EncodedString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

- (NSString *)base64EncodedURLSafeString
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedURLSafeString];
}

- (NSData *)base64DecodedData
{
    // Restore the URL-safe string to a original base64 encoded string
    NSString *string = [[self stringByReplacingOccurrencesOfString:@"-" withString:@"+"]
                        stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    NSUInteger equalLength = string.length % 4;
    if (equalLength) {
        string = [string stringByPaddingToLength:string.length + 4 - equalLength withString:@"=" startingAtIndex:0];
    }

    return [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)base64DecodedString
{
    return self.base64DecodedData.UTF8String;
}

@end
