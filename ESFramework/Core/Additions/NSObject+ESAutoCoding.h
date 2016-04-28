//
//  NSObject+ESAutoCoding.h
//  ESFramework
//
//  Created by Elf Sundae on 15/8/22.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"

#define ES_CODING_IMPLEMENTATION \
- (id)initWithCoder:(NSCoder *)aDecoder { \
        return [self initWithCoder_es:aDecoder]; \
} \
- (void)encodeWithCoder:(NSCoder *)aCoder { \
        [self es_encodeWithCoder:aCoder]; \
}

#define ES_SECURECODING_IMPLEMENTATION \
ES_CODING_IMPLEMENTATION \
+ (BOOL)supportsSecureCoding { \
        return YES; \
}

#define ES_COPYING_IMPLEMENTATION \
- (id)copyWithZone:(NSZone *)zone { \
        return [self es_copyWithZone:zone]; \
}

/*!
 * The ESAutoCoding category for NSObject makes it easiest for your models or other objects to
 * support NSCoding or NSCopying. 
 *
 * ESAutoCoding inspired by [nicklockwood/AutoCoding](https://github.com/nicklockwood/AutoCoding)
 *
 * ### Supported Property Types
 * These types below will be automatically encoded.
 *
 * + `id`
 * + basic number types like `char` `int` `long` `float` `double` `unsigned long long`, etc.
 * + `NSValue`
 * + `struct`, like `CGRect` `CGSize` `CGAffineTransform`, etc.
 *
 * ### Descussion
 * 1. To exclude certain properties of your object from being encoded,
 * you can do so in any of the following ways:
 *      * Only use an ivar, without declaring a matching `@property`.
 *      * Change the name of the ivar to something that is not KVC compliant.
 *              (not the same as the property name, or the property name with an `_` prefix,
 *              or `@synthesize` the ivar an another name, `@synthesize name = __name`
 *              (here ivar with two `_` prefix))
 *      * Override the `+es_codableProperties` method
 * 2. You can add additional coding/decoding logic by overriding the `-modelSetWithCoder:` and/or
 * the `-encodeWithCoder:` methods. As long as you call the `[super ...]` implementation,
 * the auto-coding will still function.
 *
 */
@interface NSObject (ESAutoCoding)

/// NSCoding Delegate
- (id)initWithCoder_es:(NSCoder *)aDecoder;
- (void)es_encodeWithCoder:(NSCoder *)aCoder;

/// NSCopying Delegate
- (id)es_copyWithZone:(NSZone *)zone;

+ (instancetype)es_objectWithContentsOfFile:(NSString *)filePath;
- (BOOL)es_writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;
- (void)es_writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile completion:(void (^)(BOOL result))completion;

/// @{ property_name : property_class }
+ (NSDictionary *)es_codableProperties;
- (NSDictionary *)es_dictionaryRepresentation;
- (NSString *)es_description;

@end
