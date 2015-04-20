//
//  ESCryptor.m
//  ESFramework
//
//  Created by Elf Sundae on 4/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESCryptor.h"

@implementation ESCryptor

+ (NSData *)_es_crypted:(CCOperation)operation data:(NSData *)data withAlgorithm:(CCAlgorithm)algorithm key:(id)key iv:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error
{
        NSMutableData *keyData = nil;
        NSMutableData *ivData = nil;
        
        if ([key isKindOfClass:[NSData class]]) {
                keyData = [(NSData *)key mutableCopy];
        } else if ([key isKindOfClass:[NSString class]]) {
                keyData = [[(NSString *)key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
        } else {
                printf("%s: 'key' must be a NSData or a NSString.\n", __PRETTY_FUNCTION__);
                if (error) {
                        *error = kCCParamError;
                }
                return nil;
        }
        
        size_t keySize = keyData.length;//keyLength;
        size_t ivLength = 0;
        
        if (kCCAlgorithmAES == algorithm) {
                if (keySize < kCCKeySizeAES128) {
                        keySize = kCCKeySizeAES128;
                } else if (keySize < kCCKeySizeAES192) {
                        keySize = kCCKeySizeAES192;
                } else {
                        keySize = kCCKeySizeAES256;
                }
                ivLength = kCCBlockSizeAES128;
        } else if (kCCAlgorithmDES == algorithm) {
                keySize = kCCKeySizeDES;
                ivLength = kCCBlockSizeDES;
        } else if (kCCAlgorithm3DES == algorithm) {
                keySize = kCCKeySize3DES;
                ivLength = kCCBlockSize3DES;
        } else if (kCCAlgorithmCAST == algorithm) {
                keySize = MIN(MAX(keySize, kCCKeySizeMinCAST), kCCKeySizeMaxCAST);
                ivLength = kCCBlockSizeCAST;
        } else if (kCCAlgorithmRC4 == algorithm) {
                keySize = MIN(MAX(keySize, kCCKeySizeMinRC4), kCCKeySizeMaxRC4);
        } else if (kCCAlgorithmRC2 == algorithm) {
                keySize = MIN(MAX(keySize, kCCKeySizeMinRC2), kCCKeySizeMaxRC2);
                ivLength = kCCBlockSizeRC2;
        } else if (kCCAlgorithmBlowfish == algorithm) {
                keySize = MIN(MAX(keySize, kCCKeySizeMinBlowfish), kCCKeySizeMaxBlowfish);
                ivLength = kCCBlockSizeBlowfish;
        }
        
        [keyData setLength:(NSUInteger)keySize];
        
        if (iv != nil && ivLength > 0) {
                if ([iv isKindOfClass:[NSData class]]) {
                        ivData = [(NSData *)iv mutableCopy];
                } else if ([iv isKindOfClass:[NSString class]]) {
                        ivData = [[(NSString *)iv dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
                } else {
                        printf("%s: 'iv' must be a NSData or a NSString, or nil.\n", __PRETTY_FUNCTION__);
                        if (error) {
                                *error = kCCParamError;
                        }
                        return nil;
                }
                [ivData setLength:ivLength];
        }
        
        NSData *resultData = nil;
        CCCryptorRef cryptor = NULL;
        CCCryptorStatus status = CCCryptorCreate(operation, algorithm, options,
                                                 keyData.bytes, keyData.length,
                                                 ivData ? ivData.bytes : NULL,
                                                 &cryptor);
        if (kCCSuccess == status) {
                size_t bufferSize = CCCryptorGetOutputLength(cryptor, (size_t)[data length], true);
                void *buffer = malloc(bufferSize);
                size_t buffer_used = 0;
                status = CCCryptorUpdate(cryptor, data.bytes, (size_t)data.length,
                                         buffer, bufferSize,
                                         &buffer_used);
                
                if (kCCSuccess == status) {
                        size_t totalBytes = buffer_used;
                        //  Need to update buf ptr past used bytes when calling CCCryptorFinal()
                        status = CCCryptorFinal(cryptor, buffer + buffer_used, bufferSize - buffer_used, &buffer_used);
                        if (kCCSuccess == status) {
                                totalBytes += buffer_used;
                                resultData = [NSData dataWithBytesNoCopy:buffer length:totalBytes];
                        } else {
                                free(buffer);
                        }
                        
                } else {
                        free(buffer);
                }
                
                CCCryptorRelease(cryptor);
        }
        
        if (error) {
                *error = status;
        }
        return resultData;
}

+ (NSData *)encryptedData:(NSData *)data withAlgorithm:(CCAlgorithm)algorithm key:(id)key iv:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error
{
        return [self _es_crypted:kCCEncrypt data:data withAlgorithm:algorithm key:key iv:iv options:options error:error];
}

+ (NSData *)decryptedData:(NSData *)data withAlgorithm:(CCAlgorithm)algorithm key:(id)key iv:(id)iv options:(CCOptions)options error:(CCCryptorStatus *)error
{
        return [self _es_crypted:kCCDecrypt data:data withAlgorithm:algorithm key:key iv:iv options:options error:error];
}

@end

@implementation NSData (ESCryptor)

- (NSData *)es_aesEncryptedDataWithKey:(id)key iv:(id)iv;
{
        return [ESCryptor encryptedData:self withAlgorithm:kCCAlgorithmAES
                                    key:key
                                     iv:iv
                                options:(kCCOptionPKCS7Padding|(iv ? 0 : kCCOptionECBMode))
                                  error:NULL];
}

@end
