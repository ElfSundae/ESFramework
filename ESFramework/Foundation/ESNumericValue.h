//
//  ESNumericValue.h
//  ESFramework
//
//  Created by Elf Sundae on 2020/01/13.
//  Copyright © 2020 https://0x123.com . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// Extracts numeric value from an NSNumber or NSString object safely.

FOUNDATION_EXPORT char ESCharValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned char ESUnsignedCharValue(id _Nullable obj);
FOUNDATION_EXPORT short ESShortValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned short ESUnsignedShortValue(id _Nullable obj);
FOUNDATION_EXPORT int ESIntValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned int ESUnsignedIntValue(id _Nullable obj);
FOUNDATION_EXPORT long ESLongValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned long ESUnsignedLongValue(id _Nullable obj);
FOUNDATION_EXPORT long long ESLongLongValue(id _Nullable obj);
FOUNDATION_EXPORT unsigned long long ESUnsignedLongLongValue(id _Nullable obj);
FOUNDATION_EXPORT float ESFloatValue(id _Nullable obj);
FOUNDATION_EXPORT double ESDoubleValue(id _Nullable obj);
FOUNDATION_EXPORT BOOL ESBoolValue(id _Nullable obj);
FOUNDATION_EXPORT NSInteger ESIntegerValue(id _Nullable obj);
FOUNDATION_EXPORT NSUInteger ESUnsignedIntegerValue(id _Nullable obj);

/**
 * Attempts convert an NSString/NSNumber object to an NSString object.
 */
FOUNDATION_EXPORT NSString * _Nullable ESStringValue(id _Nullable obj);

@interface NSNumber (ESNumericValue)

/**
 * Returns an NSNumber object extracted from the given string.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

@end

@interface NSString (ESNumericValue)

/**
 * Returns an NSNumber object created by parsing the string.
 */
- (nullable NSNumber *)numberValue;

@property (readonly) char charValue;
@property (readonly) unsigned char unsignedCharValue;
@property (readonly) short shortValue;
@property (readonly) unsigned short unsignedShortValue;
@property (readonly) unsigned int unsignedIntValue;
@property (readonly) long longValue;
@property (readonly) unsigned long unsignedLongValue;
@property (readonly) unsigned long long unsignedLongLongValue;
@property (readonly) NSUInteger unsignedIntegerValue;

@end

NS_ASSUME_NONNULL_END
