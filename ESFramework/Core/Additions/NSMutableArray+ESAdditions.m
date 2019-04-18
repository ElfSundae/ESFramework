//
//  NSMutableArray+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/17.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSMutableArray+ESAdditions.h"

@implementation NSMutableArray (ESAdditions)

- (void)replaceObject:(id)object withObject:(id)anObject
{
    NSUInteger index = [self indexOfObject:object];
    if (NSNotFound != index) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

@end
