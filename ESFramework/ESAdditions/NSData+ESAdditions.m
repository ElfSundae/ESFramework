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

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block
{
        ESWeakSelf;
        ESDispatchOnDefaultQueue(^{
                ESStrongSelf;
                BOOL result = NO;
                if (ESTouchDirectoryAtFilePath(path)) {
                        result = [_self writeToFile:path atomically:useAuxiliaryFile];
                }
                if (block) {
                        ESDispatchOnMainThreadAsynchrony(^{
                                block(result);
                        });
                }
        });
}

@end
