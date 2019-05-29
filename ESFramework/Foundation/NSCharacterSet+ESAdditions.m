//
//  NSCharacterSet+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/15.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSCharacterSet+ESAdditions.h"

@implementation NSCharacterSet (ESAdditions)

+ (NSCharacterSet *)URLEncodingAllowedCharacterSet
{
    static NSCharacterSet *_URLEncodingAllowedCharacterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *charset = [NSMutableCharacterSet alphanumericCharacterSet];
        [charset addCharactersInString:@"-_.~"];
        _URLEncodingAllowedCharacterSet = [charset copy];
    });

    return _URLEncodingAllowedCharacterSet;
}

@end
