//
//  NSHTTPURLResponse+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/06/24.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSHTTPURLResponse (ESExtension)

/**
 * Returns the date of response header field "Date".
 */
- (nullable NSDate *)date;

@end

NS_ASSUME_NONNULL_END
