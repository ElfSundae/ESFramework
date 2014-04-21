//
//  ESApp+Subclass.m
//  ESFramework
//
//  Created by Elf Sundae on 4/21/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESApp.h"
#import "ESApp+ESInternal.h"
@implementation ESApp (Subclass)

- (void)setupRootViewController
{
        _rootViewController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
}

@end
