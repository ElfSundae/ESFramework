//
//  AppDelegate.m
//  iOS Example
//
//  Created by Elf Sundae on 2019/05/16.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "AppDelegate.h"
#import <ESFramework/ESFramework.h>
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = self.rootViewController =
        [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];

    NSTimeZone.defaultTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    NSLog(@"%@", application.analyticsInfo);
    NSLog(@"%@", application.userAgentForHTTPRequest);

#if !TARGET_IPHONE_SIMULATOR
    [application registerForRemoteNotificationsWithSuccess:^(NSData * _Nonnull deviceToken) {
        NSLog(@"device token: %@", UIDevice.currentDevice.deviceTokenString);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
#endif

    [self.window makeKeyAndVisible];
    return YES;
}

@end
