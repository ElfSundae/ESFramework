//
//  NSURL+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ESAdditions)

- (BOOL)isEqualToURL:(NSURL *)anotherURL;
- (NSDictionary *)queryDictionary;

@end
