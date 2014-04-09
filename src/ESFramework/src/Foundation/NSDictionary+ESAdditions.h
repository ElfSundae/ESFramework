//
//  NSDictionary+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ESAdditions)

/**
 * If the object is [NSNull null], it will returns #nil.
 * It is useful while accessing a JSONObject which parsed
 * from JSON data.
 */
- (id)smartObjectForKey:(id)key;

@end
