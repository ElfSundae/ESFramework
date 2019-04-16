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
 * Initializes and returns a newly created NSURLComponents with the components of this URL.
 */
- (NSURLComponents *)components;

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

@end
