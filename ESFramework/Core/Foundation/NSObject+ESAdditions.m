//
//  NSObject+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 5/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSObject+ESAdditions.h"

@implementation NSObject (ESAdditions)

+ (instancetype)newInstance
{
        return [[[self class] alloc] init];
}


@end
