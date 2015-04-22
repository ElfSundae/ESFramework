//
//  UIDevice+ESNetworkReachability.h
//  ESFramework
//
//  Created by Elf Sundae on 4/22/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESNetworkReachability.h"

/**
 * UIDevice has started monitoring network reachability status changes for
 * `sharedNetworkReachabilityForInternetConnection`. 
 * You can listen `ESNetworkReachabilityDidChangeNotification` to receive notification.
 * The `object` of notification will be a instance of `ESNetworkReachability`.
 *
 * @code
 * [[NSNotificationCenter defaultCenter] addObserver:self
 *                                          selector:@selector(networkReachabilityDidChange:)
 *                                              name:ESNetworkReachabilityDidChangeNotification
 *                                            object:[UIDevice sharedNetworkReachabilityForInternetConnection]];
 *
 * @code
 */
@interface UIDevice (ESNetworkReachability)

+ (ESNetworkReachability *)sharedNetworkReachabilityForInternetConnection;
+ (ESNetworkReachabilityStatus)currentNetworkReachabilityStatus;
+ (NSString *)currentNetworkReachabilityStatusString;

@end
