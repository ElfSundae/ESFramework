//
//  NSObject+ESAutoCoding.h
//  ESFramework
//
//  Created by Elf Sundae on 15/8/22.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/* NSCoding implementation */
#define ES_CODING_IMPLEMENTATION                                \
    - (instancetype)initWithCoder:(NSCoder *)aDecoder           \
    {                                                           \
        self = [super init];                                    \
        [self es_setWithCoder:aDecoder];                        \
        return self;                                            \
    }                                                           \
    - (void)encodeWithCoder:(NSCoder *)aCoder                   \
    {                                                           \
        [self es_encodeWithCoder:aCoder];                       \
    }

/* NSSecureCoding implementation */
#define ES_SECURECODING_IMPLEMENTATION                          \
    ES_CODING_IMPLEMENTATION                                    \
    + (BOOL)supportsSecureCoding                                \
    {                                                           \
        return YES;                                             \
    }

/* NSCopying -copyWithZone: implementation */
#define ES_COPYING_copyWithZone_IMPLEMENTATION                  \
    - (id)copyWithZone:(NSZone *)zone                           \
    {                                                           \
        return [self es_copyWithZone:zone];                     \
    }

/*!
 * The ESAutoCoding category on NSObject provides automatic support for
 * NSCoding and NSCopying to any object, it is inspired by
 * [nicklockwood/AutoCoding](https://github.com/nicklockwood/AutoCoding).
 *
 * Tips: https://github.com/nicklockwood/AutoCoding#tips
 *
 * @note Your object should conform to NSSecureCoding instead NSCoding whenever possible.
 */
@interface NSObject (ESAutoCoding)

/**
 * NSCoding delegate method: -encodeWithCoder: .
 */
- (void)es_encodeWithCoder:(NSCoder *)aCoder;

/**
 * NSCopying delegate method: -copyWithZone: .
 */
- (id)es_copyWithZone:(NSZone *)zone;

/**
 * Populates the object's properties using the provided `NSCoder` object, based
 * on the `codableProperties` dictionary. This is called internally by the
 * `initWithCoder:` method, but may be useful if you wish to initialise an object
 * from a coded archive after it has already been created. You could even
 * initialise the object by merging the results of several different archives by
 * calling `es_setWithCoder:` more than once.
 */
- (void)es_setWithCoder:(NSCoder *)aDecoder;

/**
 * Returns all the codable properties of the object, including those that are
 * inherited from superclasses. You should not override this method - if you
 * want to add additional properties, override the `+codableProperties` class
 * method instead.
 */
@property (nonatomic, readonly) NSDictionary<NSString *, Class> *codableProperties;

/**
 * Returns a dictionary of the values of all the codable properties of the
 * object. It is equivalent to calling `dictionaryWithValuesForKeys:` with the
 * result of `object.codableProperties.allKeys` as the parameter.
 */
@property (nonatomic, readonly) NSDictionary<NSString *, id> *dictionaryRepresentation;

/**
 * Returns a string that represents the contents of the receiving class.
 */
@property (nonatomic, readonly) NSString *es_description;

/**
 * Attempts to load the file using the following sequence: 1) If the file is an
 * NSCoded archive, load the root object and return it; 2) If the file is an
 * ordinary Plist, load and return the root object; 3) Return the raw data as an
 * `NSData` object. If the de-serialised object is not a subclass of the class
 * being used to load it, an exception will be thrown (to avoid this, call the
 * method on `NSObject` instead of a specific subclass).
 */
+ (instancetype)es_objectWithContentsOfFile:(NSString *)filePath;

/**
 * Attempts to write the file to disk. This method is overridden by the
 * equivalent methods for `NSData`, `NSDictionary` and `NSArray`, which save the
 * file as a human-readable XML Plist rather than a binary NSCoded Plist archive,
 * but the `objectWithContentsOfFile:` method will correctly de-serialise these
 * again anyway. For any other object it will serialise the object using the
 * `NSCoding` protocol and write out the file as a NSCoded binary Plist archive.
 * Returns `YES` on success and `NO` on failure.
 */
- (BOOL)es_writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

/**
 * Returns a dictionary containing the names and classes of all the properties of
 * the class that will be automatically saved, loaded and copied when the object
 * is archived using `NSKeyedArchiver/Unarchiver`. The values of the dictionary
 * represent the class used to encode each property (e.g. `NSString` for strings,
 * `NSNumber` for numeric values or booleans, `NSValue` for structs, etc).
 *
 * This dictionary is automatically generated by scanning the properties defined
 * in the class definition at runtime. Read-only and private properties will also
 * be coded as long as they have KVC-compliant ivar names (i.e. the ivar matches
 * the property name, or is the same but with a _ prefix). Any properties that
 * are not backed by an ivar, or whose ivar name does not match the property name
 * will not be encoded (this is a design feature, not a limitation - it makes it
 * easier to exclude properties from encoding)
 *
 * It is not normally necessary to override this method unless you wish to add
 * ivars for coding that do not have matching property definitions, or if you
 * wish to code virtual properties (properties or setter/getter method pairs that
 * are not backed by an ivar). If you wish to exclude certain properties from the
 * serialisation process, you can deliberately give them an non KVC-compliant
 * ivar name (see above).
 *
 * Note that this method only returns the properties defined on a particular
 * class and not any properties that are inherited from its superclasses. You
 * *do not* need to call `[super codableProperties]` if you override this method.
 */
+ (NSDictionary<NSString *, Class> *)codableProperties;

@end
