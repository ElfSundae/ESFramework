//
//  NSUserDefaults+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ESAdditions)

/**
 * Set an object for the property identified by a given key path to a given value.
 *
 * @param    object                  The object for the property identified by _keyPath_.
 * @param    keyPath                 A key path of the form _relationship.property_ (with one or more relationships): for example “department.name” or “department.manager.lastName.”
 */
- (void)setObject:(id)object forKeyPath:(NSString *)keyPath;

/**
 * Set an object for the property identified by a given key path to a given value, with optional parameters to control creation and replacement of intermediate objects.
 *
 * @param    object                  The object for the property identified by _keyPath_.
 * @param    keyPath                 A key path of the form _relationship.property_ (with one or more relationships): for example “department.name” or “department.manager.lastName.”
 * @param    createIntermediates     Intermediate dictionaries defined within the key path that do not currently exist in the receiver are created.
 * @param    replaceIntermediates    Intermediate objects encountered in the key path that are not a direct subclass of `NSDictionary` are replaced.
 */
- (void)setObject:(id)object forKeyPath:(NSString *)keyPath createIntermediateDictionaries:(BOOL)createIntermediates replaceIntermediateObjects:(BOOL)replaceIntermediates;

/// =============================================
/// @name Quick methods for standardUserDefaults
/// =============================================

/**
 * Returns the object associated with the first occurrence of the `standardUserDefaults`.
 */
+ (id)objectForKey:(NSString *)defaultName;
/**
 * Sets the value of the specified default key in the `standardUserDefaults`.
 *
 * @note after set value, the `standardUserDefaults` will be synchronized to disk by invoking `-synchronize`.
 */
+ (void)setObject:(id)value forKey:(NSString *)defaultName;
/**
 * Sets the value of the specified default key in the `standardUserDefaults`, then asynchronously write to disk.
 *
 * @note after set value, the `standardUserDefaults` will be synchronized to disk by invoking `-synchronize`.
 */
+ (void)setObjectAsynchrony:(id)value forKey:(NSString *)defaultName;
/**
 * Removes the value of the standardUserDefaults key.
 *
 * @note after removing, the `standardUserDefaults` will be synchronized to disk by invoking `-synchronize`.
 */
+ (void)removeObjectForKey:(NSString *)defaultName;
/**
 * Removes the value of the standardUserDefaults key, then asynchronously write to disk.
 *
 * @note after removing, the `standardUserDefaults` will be synchronized to disk by invoking `-synchronize`.
 */
+ (void)removeObjectAsynchronyForKey:(NSString *)defaultName;

/// =============================================
/// @name NSRegistrationDomain
/// =============================================

/**
 * Returns the dictionary for the registration domain (NSRegistrationDomain).
 */
+ (NSDictionary *)registeredDefaults;
/**
 * Adds the contents of the specified dictionary to the registration domain (NSRegistrationDomain).
 *
 * @param registrationDictionary The dictionary of keys and values you want to register.
 *
 * @discuss The contents of the registration domain are not written to disk; you need to call this method each time your application starts. You can place a plist file in the application's Resources directory and call registerDefaults: with the contents that you read in from that file.
 */
+ (void)registerDefaults:(NSDictionary *)registrationDictionary;
/**
 * Removes a given defaultName and its associated value from the registration dictionary.
 */
+ (void)unregisterDefaultsForKey:(NSString *)defaultName;
/**
 * Removes from the registration dictionary entries specified by elements in a given defaultNames array.
 */
+ (void)unregisterDefaultsForKeys:(NSArray *)defaultNames;
/**
 * Replaces the associated value of the given defaultName from the registration dictionary.
 * If the value is nil, it will unregister(remove) the given defaultName.
 * If the defaultName does not exist, it will register(add) the given defaultName and value.
 */
+ (void)replaceRegisteredObject:(id)value forKey:(NSString *)defaultName;
/**
 * Sets the dictionary for the registration domain (NSRegistrationDomain).
 *
 * @warning This method will replace the whole entried of the registration domain (NSRegistrationDomain),
 * including the values which system generated, such as "AppleLanguages", "NSLanguages", etc.
 * So use it carefully.
 */
+ (void)replaceRegisteredDefaults:(NSDictionary *)registrationDictionary;

@end
