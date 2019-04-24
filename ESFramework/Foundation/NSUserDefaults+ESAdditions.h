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
/// @name NSRegistrationDomain
/// =============================================

/**
 * Returns the dictionary for the registration domain (NSRegistrationDomain).
 */
+ (NSDictionary *)registeredDefaults;

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
