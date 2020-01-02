//
//  NSData+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2016/01/23.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "NSData+ESExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (ESExtension)

// https://opensource.apple.com/source/Security/Security-55471/libsecurity_transform/NSData+HexString.m
// https://stackoverflow.com/q/2338975/521946
+ (nullable instancetype)dataWithHexString:(NSString *)hexString
{
    NSUInteger hexStringLength = hexString.length;
    if (0 == hexStringLength) {
        return nil;
    }
    if (0 != hexStringLength % 2) {
        // hexString should have an even number of digits
        return nil;
    }

    NSUInteger bytesLength = hexStringLength / 2;
    unsigned char *bytes = (unsigned char *)malloc(bytesLength);
    unsigned char *pBytes = bytes;
    const char *scanner = hexString.UTF8String;
    char str[3] = {'\0', '\0', '\0'};

    for (NSUInteger i = 0; i < bytesLength; i++) {
        str[0] = *scanner++;
        str[1] = *scanner++;
        char *end = NULL;
        *pBytes++ = strtol(str, &end, 16);
        if (end != str + 2) {
            // hexString should be all hex digits
            free(bytes);
            return nil;
        }
    }

    return [NSData dataWithBytesNoCopy:bytes length:bytesLength freeWhenDone:YES];
}

- (NSString *)UTF8String
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)lowercaseHexString
{
    NSUInteger length = self.length;
    NSMutableString *hexString = [NSMutableString stringWithCapacity:length * 2];
    const unsigned char *bytes = (const unsigned char *)self.bytes;
    for (NSUInteger i = 0; i < length; i++) {
        [hexString appendFormat:@"%02.2hhx", bytes[i]];
    }
    return [hexString copy];
}

- (NSString *)uppercaseHexString
{
    return [[self lowercaseHexString] uppercaseString];
}

- (id)JSONObject
{
    return [self JSONObjectWithOptions:0];
}

- (id)JSONObjectWithOptions:(NSJSONReadingOptions)options
{
    return [NSJSONSerialization JSONObjectWithData:self options:options error:NULL];
}

- (NSData *)md5HashData
{
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)md5HashString
{
    return [[self md5HashData] lowercaseHexString];
}

- (NSData *)sha1HashData
{
    unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha1HashString
{
    return [[self sha1HashData] lowercaseHexString];
}

- (NSData *)sha224HashData
{
    unsigned char buffer[CC_SHA224_DIGEST_LENGTH];
    CC_SHA224(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA224_DIGEST_LENGTH];
}

- (NSString *)sha224HashString
{
    return [[self sha224HashData] lowercaseHexString];
}

- (NSData *)sha256HashData
{
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha256HashString
{
    return [[self sha256HashData] lowercaseHexString];
}

- (NSData *)sha384HashData
{
    unsigned char buffer[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA384_DIGEST_LENGTH];
}

- (NSString *)sha384HashString
{
    return [[self sha384HashData] lowercaseHexString];
}

- (NSData *)sha512HashData
{
    unsigned char buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(self.bytes, (CC_LONG)self.length, buffer);
    return [NSData dataWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)sha512HashString
{
    return [[self sha512HashData] lowercaseHexString];
}

- (NSData *)es_hmacHashDataWithAlgorithm:(CCHmacAlgorithm)algorithm key:(NSData *)key
{
    size_t size = 0;
    switch (algorithm) {
        case kCCHmacAlgMD5:
            size = CC_MD5_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA1:
            size = CC_SHA1_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA224:
            size = CC_SHA224_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA256:
            size = CC_SHA256_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA384:
            size = CC_SHA384_DIGEST_LENGTH;
            break;
        case kCCHmacAlgSHA512:
            size = CC_SHA512_DIGEST_LENGTH;
            break;
        default:
            [NSException raise:NSInvalidArgumentException format:@"Invalid hmac algorithm"];
            break;
    }

    unsigned char buffer[size];
    CCHmac(algorithm, key.bytes, key.length, self.bytes, self.length, buffer);
    return [NSData dataWithBytes:buffer length:(NSUInteger)size];
}

- (NSString *)es_hmacHashStringWithAlgorithm:(CCHmacAlgorithm)algorithm key:(NSString *)key
{
    return [[self es_hmacHashDataWithAlgorithm:algorithm
                                           key:[key dataUsingEncoding:NSUTF8StringEncoding]]
            lowercaseHexString];
}

- (NSData *)hmacMD5HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgMD5 key:key];
}

- (NSString *)hmacMD5HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgMD5 key:key];
}

- (NSData *)hmacSHA1HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA1 key:key];
}

- (NSString *)hmacSHA1HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA1 key:key];
}

- (NSData *)hmacSHA224HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA224 key:key];
}

- (NSString *)hmacSHA224HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA224 key:key];
}

- (NSData *)hmacSHA256HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA256 key:key];
}

- (NSString *)hmacSHA256HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA256 key:key];
}

- (NSData *)hmacSHA384HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA384 key:key];
}

- (NSString *)hmacSHA384HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA384 key:key];
}

- (NSData *)hmacSHA512HashDataWithKey:(NSData *)key
{
    return [self es_hmacHashDataWithAlgorithm:kCCHmacAlgSHA512 key:key];
}

- (NSString *)hmacSHA512HashStringWithKey:(NSString *)key
{
    return [self es_hmacHashStringWithAlgorithm:kCCHmacAlgSHA512 key:key];
}

- (NSData *)base64EncodedData
{
    return [self base64EncodedDataWithOptions:0];
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithOptions:0];
}

- (NSString *)base64EncodedURLSafeString
{
    return [[[self.base64EncodedString
              stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
             stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
            stringByReplacingOccurrencesOfString:@"=" withString:@""];
}

- (NSData *)base64DecodedData
{
    return [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString *)base64DecodedString
{
    return self.base64DecodedData.UTF8String;
}

- (nullable NSData *)aesEncryptedDataWithKey:(NSData *)key IV:(NSData *)IV error:(NSError **)error
{
    return [self _aesCryptedDataWithOperation:kCCEncrypt key:key IV:IV error:error];
}

- (nullable NSData *)aesEncryptedDataWithKeyString:(NSString *)key IVString:(NSString *)IV error:(NSError **)error
{
    return [self aesEncryptedDataWithKey:[key dataUsingEncoding:NSUTF8StringEncoding]
                                      IV:[IV dataUsingEncoding:NSUTF8StringEncoding]
                                   error:error];
}

- (nullable NSData *)aesEncryptedDataWithHexKey:(NSString *)key hexIV:(NSString *)IV error:(NSError **)error
{
    return [self aesEncryptedDataWithKey:[NSData dataWithHexString:key]
                                      IV:[NSData dataWithHexString:IV]
                                   error:error];
}

- (nullable NSData *)aesDecryptedDataWithKey:(NSData *)key IV:(NSData *)IV error:(NSError **)error
{
    return [self _aesCryptedDataWithOperation:kCCDecrypt key:key IV:IV error:error];
}

- (nullable NSData *)aesDecryptedDataWithKeyString:(NSString *)key IVString:(NSString *)IV error:(NSError **)error
{
    return [self aesDecryptedDataWithKey:[key dataUsingEncoding:NSUTF8StringEncoding]
                                      IV:[IV dataUsingEncoding:NSUTF8StringEncoding]
                                   error:error];
}

- (nullable NSData *)aesDecryptedDataWithHexKey:(NSString *)key hexIV:(NSString *)IV error:(NSError **)error
{
    return [self aesDecryptedDataWithKey:[NSData dataWithHexString:key]
                                      IV:[NSData dataWithHexString:IV]
                                   error:error];
}

- (nullable NSData *)_aesCryptedDataWithOperation:(CCOperation)operation
                                              key:(NSData *)key
                                               IV:(NSData *)iv
                                            error:(NSError **)error
{
    if (key.length != kCCKeySizeAES128 &&
        key.length != kCCKeySizeAES192 &&
        key.length != kCCKeySizeAES256) {
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:-1
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Length of key should be 16 (128-bit), 24 (192-bit), or 32 (256-bit)" }];
        }

        return nil;
    }

    if (iv.length != kCCBlockSizeAES128) {
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:-1
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Length of iv should be 16 (128-bit)" }];
        }

        return nil;
    }

    size_t bufferSize = [self length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);

    if (!buffer) {
        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:-2
                                     userInfo:@{ NSLocalizedDescriptionKey: @"Can not allocate buffer" }];
        }

        return nil;
    }

    size_t outSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],
                                          [key length],
                                          [iv bytes],
                                          [self bytes],
                                          [self length],
                                          buffer,
                                          bufferSize,
                                          &outSize);
    if (kCCSuccess != cryptStatus) {
        free(buffer);

        if (error) {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:(NSInteger)cryptStatus
                                     userInfo:@{ NSLocalizedDescriptionKey: @"AES encryption failed" }];
        }

        return nil;
    }

    if (error) {
        *error = nil;
    }

    return [NSData dataWithBytesNoCopy:buffer length:outSize freeWhenDone:YES];
}

@end
