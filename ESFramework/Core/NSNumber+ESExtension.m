//
//  NSNumber+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/17.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSNumber+ESExtension.h"

/**
 * The character set should be removed before converting a string to a number.
 */
static NSCharacterSet *_ESRemovalCharacterSet(void)
{
    static NSCharacterSet *_removalCharacterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *charset = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [charset addCharactersInString:@","]; // grouping separator "10,000"
        _removalCharacterSet = [charset copy];
    });
    return _removalCharacterSet;
}

static NSNumberFormatter *_ESDefaultNumberFormatter(void)
{
    static NSNumberFormatter *_defaultNumberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultNumberFormatter = [[NSNumberFormatter alloc] init];
        _defaultNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _defaultNumberFormatter.usesGroupingSeparator = NO;
    });
    return _defaultNumberFormatter;
}

@implementation NSNumber (ESExtension)

+ (nullable NSNumber *)numberWithString:(NSString *)string
{
    string = [[string componentsSeparatedByCharactersInSet:_ESRemovalCharacterSet()]
              componentsJoinedByString:@""];

    if (!string || !string.length) {
        return nil;
    }

    static NSDictionary *_stringToNumberTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stringToNumberTable = @{@"true": @YES, @"t": @YES, @"yes": @YES, @"y": @YES,
                                 @"false": @NO, @"f": @NO, @"no": @NO, @"n": @NO,
                                 @"nil": [NSNull null], @"null": [NSNull null],
                                 @"<null>": [NSNull null]};
    });

    id found = _stringToNumberTable[string.lowercaseString];
    if (found) {
        if ([NSNull null] == found) {
            return nil;
        }
        return found;
    }

    return [_ESDefaultNumberFormatter() numberFromString:string];
}

@end
