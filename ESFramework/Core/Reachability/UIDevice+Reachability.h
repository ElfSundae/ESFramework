//
//  UIDevice+Reachability.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-12.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESDefines.h"
#import "Reachability.h"

ES_EXTERN NSString *const UIDeviceNetworkReachabilityChangedNotification;
ES_EXTERN NSString *const UIDeviceNetworkStatusNotReachable;
ES_EXTERN NSString *const UIDeviceNetworkStatusReachableViaWWAN;
ES_EXTERN NSString *const UIDeviceNetworkStatusReachableViaWiFi;

@interface UIDevice (Reachability)

+ (NetworkStatus)currentNetworkStatus;
+ (NSString *)currentNetworkStatusString;

/**
 * Start network notifier.
 * When the network reachability has changed, the notification "UIDeviceNetworkReachabilityChangedNotification"
 * will be posted. Then you can get the current network status from "+currentNetworkStatus" method.
 *
 * @warning It has been started on app startup.
 */
+ (BOOL)startNetworkNotifier;
/**
 * Stop network notifier.
 */
+ (void)stopNetworkNotifier;
/**
 * Checks whether network notifier has started.
 */
+ (BOOL)hasStartedNetworkNotifier;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

typedef void (^ESUIDeviceNetworkReachabilityChangedHandler)(Reachability *reachability, NetworkStatus currentNetworkStatus);

@interface NSObject (ESUIDeviceNetworkReachability)
/**
 * Set UIDeviceNetworkReachabilityChangedNotification handler. You can set #nil to stop receiving UIDeviceNetworkReachabilityChangedNotification.
 */
- (void)setNetworkReachabilityChangedHandler:(ESUIDeviceNetworkReachabilityChangedHandler)handler;
@end

