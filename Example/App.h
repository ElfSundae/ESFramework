//
//  App.h
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "ESFramework.h"
#import "RootViewController.h"

@interface App : UIResponder <UIApplicationDelegate>//ESApp <ESAppDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *rootViewController;

@end
