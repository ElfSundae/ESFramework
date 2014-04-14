//
//  NSURL+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ESAdditions)
/**
 * Parse query string to dictionary.
 */
- (NSDictionary *)queryDictionary;

@end
