//
//  App.m
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "App.h"

@implementation App
@dynamic rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        [super application:application didFinishLaunchingWithOptions:launchOptions];
        
        self.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];
        self.window.rootViewController = self.rootViewController;
        
        NSLog(@"%@", [ESApp sharedApp].analyticsInformation);
        NSLog(@"%@", [ESITunesStoreHelper appLinkForAppID:self.appStoreID storeCountryCode:ESAppStoreCountryCodeChina]);
        
        [self.window makeKeyAndVisible];
        return YES;
}

- (NSString *)appStoreID
{
        return @"12345678";
}

@end
