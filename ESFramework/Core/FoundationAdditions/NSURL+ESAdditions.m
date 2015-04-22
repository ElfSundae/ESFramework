//
//  NSURL+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSURL+ESAdditions.h"
#import "NSString+ESAdditions.h"
#import "ESDefines.h"

ES_CATEGORY_FIX(NSURL_ESAdditions)

@implementation NSURL (ESAdditions)
- (NSDictionary *)queryDictionary
{
        return [self.absoluteString queryDictionary];
}

- (BOOL)isEqualToURL:(NSURL *)anotherURL
{
        return (([self.absoluteURL isEqual:anotherURL.absoluteURL]) ||
                (self.isFileURL && anotherURL.isFileURL && [self.path isEqualToString:anotherURL.path]));
}

- (BOOL)isFileExists:(BOOL *)isDirectory
{
        return (self.isFileURL && [self.path isFileExists:isDirectory]);
}

- (BOOL)isFileExists
{
        return (self.isFileURL && [self.path isFileExists]);
}

@end
