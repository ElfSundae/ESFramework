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
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    self.window.rootViewController = self.rootViewController =
        [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];

    application.appChannel = @"dev";
    application.appStoreID = @"12345678";

    [application registerForRemoteNotifications];

    NSLog(@"%@", application.analyticsInfo);

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    UIDevice.currentDevice.deviceToken = deviceToken;
    NSLog(@"device token: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

@end
