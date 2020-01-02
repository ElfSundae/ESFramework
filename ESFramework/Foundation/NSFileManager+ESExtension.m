//
//  NSFileManager+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/09.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "NSFileManager+ESExtension.h"

@implementation NSFileManager (ESExtension)

- (BOOL)createDirectoryAtPath:(NSString *)path
{
    return [self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
}

- (BOOL)createDirectoryAtURL:(NSURL *)url
{
    return [self createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:NULL];
}

@end
