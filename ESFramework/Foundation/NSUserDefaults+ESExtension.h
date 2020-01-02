//
//  NSUserDefaults+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (ESExtension)

/**
 * The dictionary for the volatile domain NSRegistrationDomain.
 *
 * @warning Setting registrationDictionary will replace the whole entried of
 * the NSRegistrationDomain, including the values which system generated,
 * such as "AppleLanguages", "NSLanguages", etc. So use it carefully.
 */
@property (copy) NSDictionary<NSString *, id> *registrationDictionary;

/**
 * Sets the associated value of the given defaultName from the registration dictionary.
 * If the defaultName does not exist, it will register(add) the given defaultName and value.
 * If the value is nil, it will unregister(remove) the given defaultName.
 */
- (void)setRegistrationObject:(nullable id)value forKey:(NSString *)defaultName;

/**
 * Removes from the registration dictionary entries specified by elements in a given defaultNames array.
 */
- (void)removeRegistrationObjectsForKeys:(NSArray<NSString *> *)defaultNames;

@end

NS_ASSUME_NONNULL_END
