//
//  NSDictionary+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "NSDictionary+ESAdditions.h"

@implementation NSDictionary (ESAdditions)

- (id)smartObjectForKey:(id)key
{
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSNull class]]) {
                object = nil;
        }
        return object;
}

@end
