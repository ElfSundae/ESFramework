//
//  AFNetworkReachabilityManager+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 2019/04/10.
//  Copyright © 2019 www.0x123.com. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>

@interface AFNetworkReachabilityManager (ESAdditions)

/**
 * Returns a string representation of the current network reachability status.
 *
 * Possibility: "None", "WWAN", "WiFi", "Unknown".
 */
- (NSString *)networkReachabilityStatusString;

@end
