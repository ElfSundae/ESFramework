//
//  NSURL+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "NSURL+ESAdditions.h"
#import "NSString+ESAdditions.h"

@implementation NSURL (ESAdditions)

- (NSString *)appIDFromITunesURL
{
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"^http[s]://itunes.apple.com/.*/app/.*/id(\\d{9,})" options:NSRegularExpressionCaseInsensitive error:NULL];
        NSTextCheckingResult *match = [reg firstMatchInString:self.absoluteString options:0 range:NSMakeRange(0, self.absoluteString.length)];
        if (match) {
                return [self.absoluteString substringWithRange:[match rangeAtIndex:1]];
        }
        return nil;
}

@end
