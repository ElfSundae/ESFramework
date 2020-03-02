//
//  ESNumericValue.m
//  ESFramework
//
//  Created by Elf Sundae on 2020/01/13.
//  Copyright © 2020 https://0x123.com . All rights reserved.
//

#import "ESNumericValue.h"
#import "ESHelpers.h"

static NSNumber * _Nullable ESNumberFromObject(id _Nullable obj)
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        return [NSNumber numberWithString:(NSString *)obj];
    } else {
        return nil;
    }
}

char ESCharValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) charValue];
}

unsigned char ESUnsignedCharValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) unsignedCharValue];
}

short ESShortValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) shortValue];
}

unsigned short ESUnsignedShortValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) unsignedShortValue];
}

int ESIntValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) intValue];
}

unsigned int ESUnsignedIntValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) unsignedIntValue];
}

long ESLongValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) longValue];
}

unsigned long ESUnsignedLongValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) unsignedLongValue];
}

long long ESLongLongValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) longLongValue];
}

unsigned long long ESUnsignedLongLongValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) unsignedLongLongValue];
}

float ESFloatValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) floatValue];
}

double ESDoubleValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) doubleValue];
}

BOOL ESBoolValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) boolValue];
}

NSInteger ESIntegerValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) integerValue];
}

NSUInteger ESUnsignedIntegerValue(id _Nullable obj)
{
    return [ESNumberFromObject(obj) unsignedIntegerValue];
}

NSString * _Nullable ESStringValue(id _Nullable obj)
{
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)obj stringValue];
    } else {
        return nil;
    }
}

#pragma mark - NSNumber (ESNumericValue)

/**
 * A character set of separators to be removed before extracting numeric value
 * from a string, it contains whitespace, new line, and grouping separators
 * "\U00a0", "'", ",", "\U2019", "\U202f", "\U066c", "\U12c8", ".".
 */
static NSCharacterSet *ESNumericRemovingCharacterSet(void)
{
    static NSCharacterSet *_numericRemovingSeparators = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableSet *groupingSeparators = [NSMutableSet set];
        for (NSString *localeIdentifier in [NSLocale availableLocaleIdentifiers]) {
            NSLocale *locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
            [groupingSeparators addObject:[locale objectForKey:NSLocaleGroupingSeparator]];
        }

        NSMutableCharacterSet *charset = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [charset addCharactersInString:
         [groupingSeparators.allObjects componentsJoinedByString:@""]];
        _numericRemovingSeparators = [charset copy];
    });
    return _numericRemovingSeparators;
}

static NSNumberFormatter *ESDecimalNumberFormatter(void)
{
    static NSNumberFormatter *_decimalNumberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _decimalNumberFormatter = [[NSNumberFormatter alloc] init];
        _decimalNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _decimalNumberFormatter.usesGroupingSeparator = NO;
    });
    return _decimalNumberFormatter;
}

@implementation NSNumber (ESNumericValue)

+ (nullable NSNumber *)numberWithString:(NSString *)string
{
    string = [[string componentsSeparatedByCharactersInSet:ESNumericRemovingCharacterSet()]
              componentsJoinedByString:@""];

    if (!string.length) {
        return nil;
    }

    static NSDictionary *_stringToNumberTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stringToNumberTable =
            @{
                @"true": @YES, @"t": @YES, @"yes": @YES, @"y": @YES,
                @"false": @NO, @"f": @NO, @"no": @NO, @"n": @NO,
                @"nil": [NSNull null], @"null": [NSNull null],
                @"<null>": [NSNull null]
        };
    });

    id found = _stringToNumberTable[string.lowercaseString];
    if (found) {
        if ([NSNull null] == found) {
            return nil;
        }
        return found;
    }

    return [ESDecimalNumberFormatter() numberFromString:string];
}

@end

#pragma mark - NSString (ESNumericValue)

@implementation NSString (ESNumericValue)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ESSwizzleInstanceMethod(self, @selector(doubleValue), @selector(es_doubleValue));
        ESSwizzleInstanceMethod(self, @selector(floatValue), @selector(es_floatValue));
        ESSwizzleInstanceMethod(self, @selector(intValue), @selector(es_intValue));
        ESSwizzleInstanceMethod(self, @selector(integerValue), @selector(es_integerValue));
        ESSwizzleInstanceMethod(self, @selector(longLongValue), @selector(es_longLongValue));
        ESSwizzleInstanceMethod(self, @selector(boolValue), @selector(es_boolValue));
    });
}

- (double)es_doubleValue
{
    return self.numberValue.doubleValue;
}

- (float)es_floatValue
{
    return self.numberValue.floatValue;
}

- (int)es_intValue
{
    return self.numberValue.intValue;
}

- (NSInteger)es_integerValue
{
    return self.numberValue.integerValue;
}

- (long long)es_longLongValue
{
    return self.numberValue.longLongValue;
}

- (BOOL)es_boolValue
{
    return self.numberValue.boolValue;
}

- (NSNumber *)numberValue
{
    return [NSNumber numberWithString:self];
}

- (char)charValue
{
    return self.numberValue.charValue;
}

- (unsigned char)unsignedCharValue
{
    return self.numberValue.unsignedCharValue;
}

- (short)shortValue
{
    return self.numberValue.shortValue;
}

- (unsigned short)unsignedShortValue
{
    return self.numberValue.unsignedShortValue;
}

- (unsigned int)unsignedIntValue
{
    return self.numberValue.unsignedIntValue;
}

- (long)longValue
{
    return self.numberValue.longValue;
}

- (unsigned long)unsignedLongValue
{
    return self.numberValue.unsignedLongValue;
}

- (unsigned long long)unsignedLongLongValue
{
    return self.numberValue.unsignedLongLongValue;
}

- (NSUInteger)unsignedIntegerValue
{
    return self.numberValue.unsignedIntegerValue;
}

@end
