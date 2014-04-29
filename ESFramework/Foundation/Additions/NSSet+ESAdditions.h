//
//  NSSet+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-18.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (ESAdditions)
- (BOOL)isEmpty;
- (void)each:(void (^)(id obj))block;
- (void)eachConcurrently:(void (^)(id obj))block;
- (id)match:(BOOL (^)(id obj))block;
- (NSSet *)matches:(BOOL (^)(id obj))block;
- (NSSet *)reject:(BOOL (^)(id obj))block;
@end

@interface NSMutableSet (ESAdditions)
- (void)matchWith:(BOOL (^)(id obj))block;
- (void)rejectWith:(BOOL (^)(id obj))block;
@end
