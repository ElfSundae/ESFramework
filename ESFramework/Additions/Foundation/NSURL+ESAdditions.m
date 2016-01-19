//
//  NSURL+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSURL+ESAdditions.h"
#import "NSString+ESAdditions.h"

@implementation NSURL (ESAdditions)

- (BOOL)isEqualToURL:(NSURL *)anotherURL
{
        return [self.absoluteString isEqualToString:anotherURL.absoluteString];
}

- (NSDictionary *)queryDictionary
{
        return [self.absoluteString queryDictionary];
}

@end
