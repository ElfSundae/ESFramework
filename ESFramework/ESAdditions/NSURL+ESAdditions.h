//
//  NSURL+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+ESAdditions.h"

@interface NSURL (ESAdditions)
/**
 * Parse query string to dictionary.
 */
- (NSDictionary *)queryDictionary;

- (BOOL)isEqualToURL:(NSURL *)anotherURL;

- (BOOL)fileExists;
- (BOOL)fileExists:(BOOL *)isDirectory;

@end
