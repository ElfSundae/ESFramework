//
//  NSUserDefaults+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (ESAdditions)

/**
 * The dictionary for the registration domain (NSRegistrationDomain).
 *
 * @warning Setting registeredDefaults will replace the whole entried of the
 * registration domain (NSRegistrationDomain), including the values which
 * system generated, such as "AppleLanguages", "NSLanguages", etc. So use it
 * carefully.
 */
@property (nonatomic, copy) NSDictionary<NSString *, id> *registeredDefaults;

/**
 * Sets the associated value of the given defaultName from the registration dictionary.
 * If the defaultName does not exist, it will register(add) the given defaultName and value.
 * If the value is nil, it will unregister(remove) the given defaultName.
 */
- (void)setRegisteredObject:(nullable id)value forKey:(NSString *)defaultName;

/**
 * Removes from the registration dictionary entries specified by elements in a given defaultNames array.
 */
- (void)removeRegisteredObjectsForKeys:(NSArray<NSString *> *)defaultNames;

@end

NS_ASSUME_NONNULL_END
