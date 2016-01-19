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
/**
 * The `replacement` is treated as a template, with $0 being replaced by the
 * contents of the matched range, $1 by the contents of the first capture group,
 * and so on.
 * Additional digits beyond the maximum required to represent
 * the number of capture groups will be treated as ordinary characters, as will
 * a $ not followed by digits.  Backslash will escape both $ and itself.
 */
- (void)replaceRegex:(NSString *)pattern to:(NSString *)replacement caseInsensitive:(BOOL)caseInsensitive;
- (void)replaceWithDictionary:(NSDictionary *)dictionary options:(NSStringCompareOptions)options;

@end
