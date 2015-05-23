//
//  NSUserDefaults+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 5/20/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ESAdditions)

+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)object forKey:(NSString *)key;
+ (void)setObjectAsynchrony:(id)object forKey:(NSString *)key;
+ (void)removeObjectForKey:(NSString *)key;
+ (void)removeObjectAsynchronyForKey:(NSString *)key;

@end
