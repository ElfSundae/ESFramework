//
//  NSObject+ESModel.h
//  ESFramework
//
//  Created by Elf Sundae on 5/8/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDefines.h"

/**
 * Base model that support automatic `NSCoding`. 
 * Inspired by [AutoCoding](https://github.com/nicklockwood/AutoCoding) and
 * [BaseModel](https://github.com/nicklockwood/BaseModel).
 *
 * ### Supported Property Types
 * These types below will be automatically encoded.
 *
 * + `id`
 * + basic number types like `char` `int` `long` `float` `double` `unsigned long long`, etc.
 * + `NSValue`
 * + `struct`, like `CGRect` `CGSize` `CGAffineTransform`, etc.
 *
 *
 * ### NSCopying
 * If you wish to implement copying, this can be done quite easily by looping over the 
 * `modelCodablePropertiesKeys` keys and copying those properties individually to a new 
 * instance of the object (as follows):
 *
 * 	- (instancetype)copyWithZone:(NSZone *)zone
 * 	{
 * 	        TestObject *copy = [[[self class] alloc] init];
 * 	        for (NSString *key in [[self class] modelCodablePropertiesKeys]) {
 * 	                [copy setValue:[self valueForKey:key] forKey:key];
 * 	        }
 * 	        // maybe copy other non-codable properties
 * 	        copy.testNoCached = self.testNoCached;
 * 	        return copy;
 * 	}
 *
 * ### Descussion
 * 1. To exclude certain properties of your object from being encoded, 
 * you can do so in any of the following ways:
 *      * Only use an ivar, without declaring a matching `@property`.
 *      * Change the name of the ivar to something that is not KVC compliant.
 *              (not the same as the property name, or the property name with an `_` prefix,
 *              or `@synthesize` the ivar an another name, `@synthesize name = __name` 
 *              (here ivar with two `_` prefix))
 *      * Override the `+modelCodablePropertiesKeys` method
 * 2. You can add additional coding/decoding logic by overriding the `-modelSetWithCoder:` and/or
 * the `-encodeWithCoder:` methods. As long as you call the `[super ...]` implementation,
 * the auto-coding will still function.
 *
 */
@interface NSObject (ESModel)

///=============================================
/// @name Constructors
///=============================================

/**
 * Returns a new model instance.
 */
+ (instancetype)modelInstance;
/**
 * Returns `nil` if loading fail.
 */
+ (instancetype)modelWithContentsOfFile:(NSString *)filePath;

- (void)setModelWithCoder:(NSCoder *)aDecoder;

///=============================================
/// @name Shared Instance
///=============================================

/**
 * Returns the shared instance, it will load from `+modelSharedInstanceFilePath` at first.
 */
+ (instancetype)modelSharedInstance;
/**
 * Detect whether the shared instance exists.
 */
+ (BOOL)modelSharedInstanceExists;
/**
 * Set a instance to replace shared instance.
 * Set `nil` to destroy shared instance.
 */
+ (void)setModelSharedInstance:(id)instance;
/**
 * Save current object to `+modelSharedInstanceFilePath`.
 */
- (void)saveModelSharedInstance:(void (^)(BOOL result))block;
/**
 * Synchronously write file.
 */
- (void)saveModelSharedInstance;
/**
 * File path for the shared instance.
 * Default path is `{app}/Library/Caches/ESModel/{ClassName}.archive`.
 * If you do not want the shared instance to be cached to file, just return `nil`.
 */
+ (NSString *)modelSharedInstanceFilePath;


///=============================================
/// @name File Access
///=============================================

/**
 * Asynchronously write file.
 * It will create directories automatically if not exists.
 */
- (void)modelWriteToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile withBlock:(void (^)(BOOL result))block;
/**
 * Synchronously write file.
 * It will create directories automatically if not exists.
 */
- (BOOL)modelWriteToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

///=============================================
/// @name Properties Access
///=============================================

/**
 * All codable properties keys, it's not included `struct`, `block` types.
 */
+ (NSArray *)modelCodablePropertiesKeys;
/**
 * All codable properties by dictionary `name`=>`value`.
 */
- (NSDictionary *)modelDictionaryRepresentation;
/**
 * It's useful while debuging.
 */
- (NSString *)modelDescription;

@end
