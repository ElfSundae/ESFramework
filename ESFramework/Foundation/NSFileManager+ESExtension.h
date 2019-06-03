//
//  NSFileManager+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/09.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (ESExtension)

/**
 * Creates a directory with default file attributes at the specified path, any
 * non-existent parent directories will be created as well.
 *
 * @return YES if the directory was created, YES if the directory already exists,
 * or NO if an error occurred.
 */
- (BOOL)createDirectoryAtPath:(NSString *)path;

/**
 * Creates a directory with default file attributes at the specified URL, any
 * non-existent parent directories will be created as well.
 *
 * @return YES if the directory was created, YES if the directory already exists,
 * or NO if an error occurred.
 */
- (BOOL)createDirectoryAtURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
