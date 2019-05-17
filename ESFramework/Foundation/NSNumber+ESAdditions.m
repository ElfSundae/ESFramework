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
    string = string.trimmedString;
    if (!string || !string.length) {
        return nil;
    }

    static NSDictionary *table = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        table = @{@"true": @YES, @"t": @YES, @"yes": @YES, @"y": @YES,
                  @"false": @NO, @"f": @NO, @"no": @NO, @"n": @NO,
                  @"nil": NSNull.null, @"null": NSNull.null, @"<null>": NSNull.null};
    });

    id found = table[string.lowercaseString];
    if (found) {
        if (NSNull.null == found) {
            return nil;
        }
        return found;
    }

    return [NSNumberFormatter.defaultFormatter numberFromString:string];
}

@end
