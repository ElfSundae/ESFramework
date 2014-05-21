//
//  NSData+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 4/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSData+ESAdditions.h"
#import "ESDefines.h"
@implementation NSData (ESAdditions)
- (NSString *)stringValue
{
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESWeak(self, weakSelf);
        ESDispatchOnDefaultQueue(^{
                ESStrong(weakSelf, _self);
                NSString *filePath = ESTouchFilePath(path);
                if (!filePath) {
                        if (block) {
                                block(NO);
                        }
                        return;
                }
                
                BOOL res = [_self writeToFile:filePath atomically:useAuxiliaryFile];
                if (block) {
                        block(res);
                }
        });
}

@end
