//
//  NSHTTPURLResponse+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/06/24.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "NSHTTPURLResponse+ESExtension.h"
#import "NSDate+ESExtension.h"

@implementation NSHTTPURLResponse (ESExtension)

- (NSDate *)date
{
    NSString *value = self.allHeaderFields[@"Date"];
    return value ? [NSDate dateWithHTTPDateString:value] : nil;
}

@end
