//
//  NSMutableDictionary+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/19.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (ESAdditions)

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

@end
