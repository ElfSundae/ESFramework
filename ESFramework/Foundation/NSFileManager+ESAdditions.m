//
//  NSFileManager+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/09.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSFileManager+ESAdditions.h"

@implementation NSFileManager (ESAdditions)

- (BOOL)createDirectoryAtPath:(NSString *)path
{
    return [self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
}

- (BOOL)createDirectoryAtURL:(NSURL *)url
{
    return [self createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:NULL];
}

@end
