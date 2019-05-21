//
//  AppDelegate.m
//  iOS Example
//
//  Created by Elf Sundae on 2019/05/16.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.appChannel = @"dev";
    application.appStoreID = @"12345678";

    NSTimeZone.defaultTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;

    self.window.rootViewController = self.rootViewController =
        [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];

    [application registerForRemoteNotificationsWithCompletion:^(NSData * _Nullable deviceToken, NSError * _Nullable error) {
        if (deviceToken) {
            NSLog(@"device token: %@", UIDevice.currentDevice.deviceTokenString);
        }
    }];

    NSLog(@"%@", application.analyticsInfo);

    [self.window makeKeyAndVisible];
    return YES;
}

@end
