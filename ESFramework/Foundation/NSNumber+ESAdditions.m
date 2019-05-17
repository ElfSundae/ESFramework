//
//  NSNumber+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/17.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSNumber+ESAdditions.h"
#import "NSString+ESAdditions.h"
#import "NSNumberFormatter+ESAdditions.h"

@implementation NSNumber (ESAdditions)

+ (nullable NSNumber *)numberWithString:(NSString *)string
{
    string = string.trimmedString.lowercaseString;
    if (!string || !string.length) {
        return nil;
    }

    if ([string isEqualToString:@"true"] || [string isEqualToString:@"yes"]) {
        return @YES;
    } else if ([string isEqualToString:@"false"] || [string isEqualToString:@"no"]) {
        return @NO;
    } else if ([string isEqualToString:@"nil"] ||
               [string isEqualToString:@"null"] ||
               [string isEqualToString:@"<null>"]) {
        return nil;
    }

    return [NSNumberFormatter.defaultFormatter numberFromString:string];
}

@end
