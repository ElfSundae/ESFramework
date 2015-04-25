//
//  NSData+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 4/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSData+ESAdditions.h"
#import "ESDefines.h"

ES_CATEGORY_FIX(NSData_ESAdditions)

@implementation NSData (ESAdditions)

- (NSString *)stringValue
{
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)hexStringValue
{
        NSMutableString *hexString = [NSMutableString string];
        const unsigned char *p = self.bytes;
        for (NSUInteger i = 0; i < self.length; i++) {
                [hexString appendFormat:@"%02x", *p++];
        }
        return hexString;
}

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESWeakSelf;
        ESDispatchOnDefaultQueue(^{
                ESStrongSelf;
                NSString *filePath = ESTouchFilePath(path);
                if (!filePath) {
                        if (block) {
                                ESDispatchOnMainThreadAsynchrony(^{
                                        block(NO);
                                });
                        }
                } else {
                        BOOL res = [_self writeToFile:filePath atomically:useAuxiliaryFile];
                        if (block) {
                                ESDispatchOnMainThreadAsynchrony(^{
                                        block(res);
                                });
                        }       
                }
        });
}

@end