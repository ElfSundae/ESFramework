//
//  NSMutableString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 15/12/28.
//  Copyright © 2015年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (ESAdditions)

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options;

- (void)replaceWithDictionary:(NSDictionary<NSString *, NSString *> *)dictionary options:(NSStringCompareOptions)options;

@end
