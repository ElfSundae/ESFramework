//
//  App.m
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "App.h"
#import "RootViewController.h"

@implementation App
@dynamic rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    self.window.rootViewController =
        self.rootViewController =
            [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];

    application.appChannel = @"dev";
    application.appStoreID = @"12345678";

    NSLog(@"%@", application.analyticsInfo);
    NSLog(@"%@", [ESStoreHelper appLinkForAppID:application.appStoreID storeCountryCode:nil]);

    [self.window makeKeyAndVisible];
    return YES;
}

@end
