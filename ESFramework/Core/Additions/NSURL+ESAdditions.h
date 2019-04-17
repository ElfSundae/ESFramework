//
//  NSURL+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ESAdditions)

/**
 * Returns a Boolean value that indicates whether a given URL equals to this URL.
 */
- (BOOL)isEqualToURL:(NSURL *)anotherURL;

/**
 * Returns the query components parsed as a dictionary for this URL.
 * For URL http://foo.bar?key=value&arr[]=value&arr[]=value1 , the query component will be:
 * { key:value, arr:[value, value1] }.
 */
- (NSDictionary<NSString *, id> *)queryDictionary;

/**
 * Returns a newly created URL added the given query dictionary.
 */
- (NSURL *)URLByAddingQueryDictionary:(NSDictionary<NSString *, id> *)queryDictionary;

@end
