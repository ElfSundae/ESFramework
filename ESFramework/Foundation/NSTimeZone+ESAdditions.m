//
//  NSTimeZone+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/14.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSTimeZone+ESAdditions.h"

@implementation NSTimeZone (ESAdditions)

- (NSInteger)hoursFromGMT
{
    return self.secondsFromGMT / 3600;
}

@end
