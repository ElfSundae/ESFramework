//
//  NSString+ESHash.m
//  ESFramework
//
//  Created by Elf Sundae on 16/1/23.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "NSString+ESHash.h"
#import "NSData+ESHash.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ESHash)

- (NSData *)es_md5HashData
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_md5HashData];
}

- (NSString *)es_md5HashString
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_md5HashString];
}

- (NSData *)es_sha1HashData
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha1HashData];
}
- (NSString *)es_sha1HashString
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha1HashString];
}

- (NSData *)es_sha224HashData
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha224HashData];
}
- (NSString *)es_sha224HashString
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha224HashString];
}

- (NSData *)es_sha256HashData
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha256HashData];
}
- (NSString *)es_sha256HashString
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha256HashString];
}

- (NSData *)es_sha384HashData
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha384HashData];
}
- (NSString *)es_sha384HashString
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha384HashString];
}

- (NSData *)es_sha512HashData
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha512HashData];
}
- (NSString *)es_sha512HashString
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_sha512HashString];
}

- (NSData *)es_HmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_HmacHashDataWithAlgorithm:algorithm key:key];
}

- (NSString *)es_HmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_HmacHashStringWithAlgorithm:algorithm key:key];
}

- (NSData *)es_base64Encoded
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_base64Encoded];
}

- (NSString *)es_base64EncodedString
{
        return [[self dataUsingEncoding:NSUTF8StringEncoding] es_base64EncodedString];
}

- (NSData *)es_base64Decoded
{
        return [[NSData alloc] initWithBase64EncodedString:self options:0];
}

- (NSString *)es_base64DecodedString
{
        return [[self es_base64Decoded] es_stringValue];
}

@end
