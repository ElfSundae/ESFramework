//
//  NSTimeZone+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/14.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimeZone (ESAdditions)

/**
 * The current difference in hours between the receiver and Greenwich Mean Time.
 */
@property (readonly) NSInteger hoursFromGMT;

@end

NS_ASSUME_NONNULL_END
