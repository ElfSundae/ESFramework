//
//  AppDelegate.m
//  iOS Example
//
//  Created by Elf Sundae on 2019/05/16.
//  Copyright © 2014-2020 https://0x123.com All rights reserved.
//

#import "AppDelegate.h"
@import ESFramework;
@import CoreLocation;
#import "RootViewController.h"

@interface AppDelegate () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RootViewController alloc] init]];

    NSTimeZone.defaultTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    NSLog(@"%@", UIApplication.sharedApplication.userAgentForHTTPRequest);

    [self requestLocationAuthorization];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)requestLocationAuthorization
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self printAnalyticsInfo];
    }
}

- (void)printAnalyticsInfo
{
    NSLog(@"%@", UIApplication.sharedApplication.analyticsInfo);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }

    [self printAnalyticsInfo];

    self.locationManager = nil;
}

@end
