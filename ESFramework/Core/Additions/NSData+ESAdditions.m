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
    es_dispatch_async_default(^{
        BOOL result = (ESTouchDirectoryAtFilePath(path) &&
                       [self writeToFile:path atomically:useAuxiliaryFile]);
        if (completion) {
            es_dispatch_async_main(^{
                completion(result);
            });
        }
    });
}

@end
