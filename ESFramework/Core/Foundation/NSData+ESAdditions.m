//
//  NSData+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 4/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSData+ESAdditions.h"

@implementation NSData (ESAdditions)
- (NSString *)stringValue
{
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
@end
