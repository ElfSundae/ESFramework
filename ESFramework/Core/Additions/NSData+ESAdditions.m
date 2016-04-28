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

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile completion:(void (^)(BOOL result))completion
{
        ESDispatchOnDefaultQueue(^{
                BOOL result = (ESTouchDirectoryAtFilePath(path) &&
                               [self writeToFile:path atomically:useAuxiliaryFile]);
                ESDispatchOnMainThreadAsynchrony(^{
                        if (completion) completion(result);
                });
        });
}

@end
