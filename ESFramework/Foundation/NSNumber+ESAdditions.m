//
//  NSNumber+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/17.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSNumber+ESAdditions.h"
#import "NSString+ESAdditions.h"

@implementation NSNumber (ESAdditions)

+ (nullable NSNumber *)numberWithString:(NSString *)string
{
    string = [string stringByDeletingCharactersInString:@", "].trimmedString;
    if (!string || !string.length) {
        return nil;
    }

    static NSDictionary *_esNumberTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _esNumberTable = @{@"true": @YES, @"t": @YES, @"yes": @YES, @"y": @YES,
                           @"false": @NO, @"f": @NO, @"no": @NO, @"n": @NO,
                           @"nil": [NSNull null], @"null": [NSNull null],
                           @"<null>": [NSNull null]};
    });

    id found = _esNumberTable[string.lowercaseString];
    if (found) {
        if ([NSNull null] == found) {
            return nil;
        }
        return found;
    }

    static NSNumberFormatter *_esNumberFormatter = nil;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        _esNumberFormatter = [[NSNumberFormatter alloc] init];
        _esNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _esNumberFormatter.usesGroupingSeparator = NO;
    });

    return [_esNumberFormatter numberFromString:string];
}

@end
