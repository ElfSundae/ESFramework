//
//  NSNumberFormatter+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/24.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumberFormatter (ESAdditions)

/**
 * A shared NSNumberFormatter instance with decimal style format and without group separator.
 */
+ (instancetype)defaultFormatter;

@end

NS_ASSUME_NONNULL_END
