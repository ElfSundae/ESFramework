//
//  AFNetworkReachabilityManager+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/10.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#if !TARGET_OS_WATCH
#import <AFNetworking/AFNetworkReachabilityManager.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Returns a string representation of an `AFNetworkReachabilityStatus` value.
 * @discussion Possible values: "None", "WWAN", "WiFi", "Unknown".
 */
FOUNDATION_EXTERN NSString *ESStringFromNetworkReachabilityStatus(AFNetworkReachabilityStatus status);

@interface AFNetworkReachabilityManager (ESExtension)

/**
 * Returns a string representation of the current network reachability status.
 * @discussion Possible values: "None", "WWAN", "WiFi", "Unknown".
 */
- (NSString *)networkReachabilityStatusString;

@end

NS_ASSUME_NONNULL_END
#endif
