//
//  ESActionBlockContainer.m
//  ESFramework
//
//  Created by Elf Sundae on 2019/05/23.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "ESActionBlockContainer.h"

@implementation ESActionBlockContainer

- (instancetype)initWithBlock:(void (^ _Nullable)(id sender))block
{
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)invoke:(id)sender
{
    if (self.block) {
        self.block(sender);
    }
}

- (SEL)action
{
    return @selector(invoke:);
}

@end
