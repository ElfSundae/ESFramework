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
 * Common Encryptor.
 * 
 * http://www.seacha.com/tools/aes.html
 *
 * @param key           NSString or NSData
 *
 * @param keyLength     see kCCKeySize...
 *                      Length of key material. Must be appropriate
 *                      for the selected operation and algorithm. Some
 *                      algorithms  provide for varying key lengths.
 *
 * @param iv            NSString or NSData
 *                      Initialization vector, optional. Used by
 *                      block ciphers when Cipher Block Chaining (CBC)
 *                      mode is enabled. If present, must be the same
 *                      length as the selected algorithm's block size.
 *                      If CBC mode is selected (by the absence of the
 *                      kCCOptionECBMode bit in the options flags) and no
 *                      IV is present, a NULL (all zeroes) IV will be used.
 *                      This parameter is ignored if ECB mode is used or
 *                      if a stream cipher algorithm is selected.
 *
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


@interface NSData (ESCryptor)

/**
 * If the `iv` is nil, kCCOptionECBMode will be used, otherwise CMCMode will be use.
 */
- (NSData *)es_aesEncryptedDataWithKey:(id)key iv:(id)iv;

@end
