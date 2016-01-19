//
//  NSRegularExpression+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/19/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (ESAdditions)

+ (instancetype)regex:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError **)error;
+ (instancetype)regex:(NSString *)pattern options:(NSRegularExpressionOptions)options;
+ (instancetype)regex:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive;

- (NSArray *)matchesInString:(NSString *)string;
- (NSUInteger)numberOfMatchesInString:(NSString *)string;
- (NSTextCheckingResult *)firstMatchInString:(NSString *)string;
- (NSRange)rangeOfFirstMatchInString:(NSString *)string;
- (NSString *)stringByReplacingMatchesInString:(NSString *)string withTemplate:(NSString *)templ;
- (NSUInteger)replaceMatchesInString:(NSMutableString *)string withTemplate:(NSString *)templ;

@end

