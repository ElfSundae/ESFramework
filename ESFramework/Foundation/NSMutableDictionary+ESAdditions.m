//
//  NSMutableDictionary+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/19.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "NSDictionary+ESAdditions.h"
#import <NestedObjectSetters/NestedObjectSetters.h>

@implementation NSMutableDictionary (ESAdditions)

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath
{
    [self setObject:object forKeyPath:keyPath createIntermediateDictionaries:YES replaceIntermediateObjects:YES];
}

- (void)setObject:(id)object forKeyPath:(NSString *)keyPath createIntermediateDictionaries:(BOOL)createIntermediates replaceIntermediateObjects:(BOOL)replaceIntermediates
{
    [NestedObjectSetters setObject:object onObject:self forKeyPath:keyPath createIntermediateDictionaries:createIntermediates replaceIntermediateObjects:replaceIntermediates];
}

@end
