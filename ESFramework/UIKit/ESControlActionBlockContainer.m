//
//  ESControlActionBlockContainer.m
//  ESFramework
//
//  Created by Elf Sundae on 2020/06/17.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import "ESControlActionBlockContainer.h"
#if TARGET_OS_IOS || TARGET_OS_TV

@implementation ESControlActionBlockContainer

- (instancetype)initWithBlock:(void (^ _Nullable)(id sender))block controlEvents:(UIControlEvents)controlEvents
{
    self = [self initWithBlock:block];
    if (self) {
        self.controlEvents = controlEvents;
    }
    return self;
}

@end

#endif
