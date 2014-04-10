//
//  UIDevice+ESNetwork.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface UIDevice (ESNetwork)

+ (NetworkStatus)currentNetworkStatus;
+ (NSString *)currentNetworkStatusString;

/**
 * Start network notifier.
 * When the network reachability has changed, the notification "kReachabilityChangedNotification"
 * will be posted. Then you can get the current network status from "+currentNetworkStatus" method.
 */
+ (BOOL)startNetworkNotifier;
+ (void)stopNetworkNotifier;

@end
