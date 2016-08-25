//
//  App.m
//  Example
//
//  Created by Elf Sundae on 15/9/14.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "App.h"
#import "RootViewController.h"
#import <ESFramework/ESFramework.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <unistd.h>
#import <dlfcn.h>
#import <notify.h>
@implementation App
{
    ESNetworkReachability *baidu;
    ESNetworkReachability *test;
}
@dynamic rootViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super application:application didFinishLaunchingWithOptions:launchOptions];

    self.window.rootViewController =
        self.rootViewController =
            [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];

    NSLog(@"%@", [ESApp sharedApp].analyticsInformation);
    NSLog(@"%@", [ESStoreHelper appLinkForAppID:self.appStoreID storeCountryCode:nil]);

    NSLog(@"%@", [ESNetworkReachability defaultReachability].statusString);

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ESNetworkReachabilityDidChangeNotification:) name:ESNetworkReachabilityStatusDidChangeNotification object:nil];

    baidu = [ESNetworkReachability reachabilityWithDomain:@"www.baidu.com"];
    NSLog(@"%@", baidu.statusString);

    [baidu startMonitoring];


    //    NSString *interface = @"220.181.57.218";
    //
    //    test = [ESNetworkReachability reachabilityForLocalWiFi];
    //    NSLog(@"%@", test);
    //    [test startMonitoring];


    [self.window makeKeyAndVisible];
    return YES;
}

- (void)ESNetworkReachabilityDidChangeNotification:(NSNotification *)note
{
    NSLog(@"%@", note.object);
}

- (NSString *)appStoreID
{
    return @"12345678";
}

@end
