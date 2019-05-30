//
//  NSNumber+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/17.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (ESExtension)

/**
 * Returns a NSNumber object created by parsing a given string.
 */
+ (nullable NSNumber *)numberWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
