//
//  ESHash.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESHash.h"

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSData
@implementation NSData (ESHash)

- (NSString *)es_stringValue
{
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)es_hexStringValue
{
        NSMutableString *hexString = [NSMutableString string];
        const unsigned char *p = self.bytes;
        for (NSUInteger i = 0; i < self.length; ++i) {
                [hexString appendFormat:@"%02x", *p++];
        }
        return hexString;
}

- (NSData *)es_md5HashData
{
        unsigned char buffer[CC_MD5_DIGEST_LENGTH];
        CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
        return [NSData dataWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)es_md5HashString
{
        return [[self es_md5HashData] es_hexStringValue];
}

- (NSData *)es_sha1HashData
{
        unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
        return [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)es_sha1HashString
{
        return [[self es_sha1HashData] es_hexStringValue];
}

- (NSData *)es_sha224HashData
{
        unsigned char buffer[CC_SHA224_DIGEST_LENGTH];
        CC_SHA224(self.bytes, (CC_LONG)self.length, buffer);
        return [NSData dataWithBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}
- (NSString *)es_sha224HashString
{
        return [[self es_sha224HashData] es_hexStringValue];
}

- (NSData *)es_sha256HashData
{
        unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
        CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
        return [NSData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
- (NSString *)es_sha256HashString
{
        return [[self es_sha256HashData] es_hexStringValue];
}

- (NSData *)es_sha384HashData
{
        unsigned char buffer[CC_SHA384_DIGEST_LENGTH];
        CC_SHA384(self.bytes, (CC_LONG)self.length, buffer);
        return [NSData dataWithBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}
- (NSString *)es_sha384HashString
{
        return [[self es_sha384HashData] es_hexStringValue];
}

- (NSData *)es_sha512HashData
{
        unsigned char buffer[CC_SHA512_DIGEST_LENGTH];
        CC_SHA512(self.bytes, (CC_LONG)self.length, buffer);
        return [NSData dataWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}
- (NSString *)es_sha512HashString
{
        return [[self es_sha512HashData] es_hexStringValue];
}

- (NSData *)es_HmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
        NSData *keyData = nil;
        if ([key isKindOfClass:[NSData class]]) {
                keyData = (NSData *)key;
        } else if ([key isKindOfClass:[NSString class]]) {
                keyData = [(NSString *)key dataUsingEncoding:NSUTF8StringEncoding];
        } else {
                printf("%s: 'key' must be a NSData or a NSString.\n", __PRETTY_FUNCTION__);
                return nil;
        }
        size_t size = 0;
        if (kCCHmacAlgSHA1 == algorithm) {
                size = CC_SHA1_DIGEST_LENGTH;
        } else if (kCCHmacAlgMD5 == algorithm) {
                size = CC_MD5_DIGEST_LENGTH;
        } else if (kCCHmacAlgSHA224 == algorithm) {
                size = CC_SHA224_DIGEST_LENGTH;
        } else if (kCCHmacAlgSHA256 == algorithm) {
                size = CC_SHA256_DIGEST_LENGTH;
        } else if (kCCHmacAlgSHA384 == algorithm) {
                size = CC_SHA384_DIGEST_LENGTH;
        } else if (kCCHmacAlgSHA512 == algorithm) {
                size = CC_SHA512_DIGEST_LENGTH;
        } else {
                printf("%s: 'algorithm' is wrong.\n", __PRETTY_FUNCTION__);
                return nil;
        }
        
        unsigned char buffer[size];
        CCHmac(algorithm, keyData.bytes, keyData.length, self.bytes, self.length, buffer);
        return [NSData dataWithBytes:buffer length:(NSUInteger)size];
}

- (NSString *)es_HmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(id)key
{
        return [[self es_HmacHashDataWithAlgorithm:algorithm key:key] es_hexStringValue];
}

- (NSData *)es_base64Encoded
{
        // iOS 7+
        if ([self respondsToSelector:@selector(base64EncodedDataWithOptions:)]) {
                return [self base64EncodedDataWithOptions:0];
        }
        
        // iOS 4+
        NSString *encodingString = [self base64Encoding];
        return [encodingString dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)es_base64EncodedString
{
        // iOS 7+
        if ([self respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
                return [self base64EncodedStringWithOptions:0];
        }
        
        // iOS 4+
        return [self base64Encoding];
}

- (NSData *)es_base64Decoded
{
        if ([self respondsToSelector:@selector(initWithBase64EncodedData:options:)]) {
                return [[NSData alloc] initWithBase64EncodedData:self options:0];
        }
        
        NSString *encodedStr = self.es_stringValue;
        return [[NSData alloc] initWithBase64Encoding:encodedStr];
}


- (NSString *)es_base64DecodedString
{
        if ([self respondsToSelector:@selector(initWithBase64EncodedData:options:)]) {
                NSData *data = [[NSData alloc] initWithBase64EncodedData:self options:0];
                return data.es_stringValue;
        }
        
        NSData *data = [self es_base64Decoded];
        return data.es_stringValue;
}


@end


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSString
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
        if ([NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
                return [[NSData alloc] initWithBase64EncodedString:self options:0];
        }
        return [[NSData alloc] initWithBase64Encoding:self];
}

- (NSString *)es_base64DecodedString
{
        return [[self es_base64Decoded] es_stringValue];
}

@end
