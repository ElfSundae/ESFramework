//
//  NSMutableString+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 15/12/28.
//  Copyright © 2015年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (ESAdditions)

- (void)replace:(NSString *)string to:(NSString *)replacement options:(NSStringCompareOptions)options;
- (void)replace:(NSString *)string to:(NSString *)replacement;
- (void)replaceCaseInsensitive:(NSString *)string to:(NSString *)replacement;
- (void)replaceInRange:(NSRange)range to:(NSString *)replacement;
- (void)replaceRegex:(NSString *)pattern to:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive;
- (void)replaceWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options;

@end
