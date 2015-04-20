//
//  ESCryptor.h
//  ESFramework
//
//  Created by Elf Sundae on 4/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface ESCryptor : NSObject

/**
 * Returns correct size for key and iv data, based on algorithms and given keySize.
 */
+ (size_t)fixedKeySizeForAlgorithm:(CCAlgorithm)algorithm
                           keySize:(size_t)keySize
                         blockSize:(size_t *)blockSize;

/**
 * Common Encryptor
 */
+ (NSData *)encryptedData:(NSData *)data
            withAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                       iv:(id)iv
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error;


+ (NSData *)decryptedData:(NSData *)data
            withAlgorithm:(CCAlgorithm)algorithm
                      key:(id)key
                       iv:(id)iv
                  options:(CCOptions)options
                    error:(CCCryptorStatus *)error;

@end
