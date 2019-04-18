//
//  NSMutableArray+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/17.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray<ObjectType> (ESAdditions)

- (void)replaceObject:(ObjectType)object withObject:(ObjectType)anObject;

@end
