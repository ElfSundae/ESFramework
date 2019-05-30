//
//  AFNetworkReachabilityManager+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/10.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkReachabilityManager (ESExtension)

/**
 * Returns a string representation of the current network reachability status.
 *
 * Possible values: "None", "WWAN", "WiFi", "Unknown".
 */
- (NSString *)networkReachabilityStatusString;

@end

NS_ASSUME_NONNULL_END
