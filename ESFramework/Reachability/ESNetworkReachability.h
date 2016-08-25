//
//  ESNetworkReachability.h
//  ESFramework
//
//  Created by Elf Sundae on 2016/08/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef NS_ENUM(NSInteger, ESNetworkReachabilityStatus) {
    ESNetworkReachabilityStatusNotReachable = 0,
    ESNetworkReachabilityStatusReachableViaWWAN,
    ESNetworkReachabilityStatusReachableViaWiFi
};

#define ESNetworkReachabilityStatusStringNotReachable           @"None"
#define ESNetworkReachabilityStatusStringReachableViaWWAN       @"WWAN"
#define ESNetworkReachabilityStatusStringReachableViaWiFi       @"WiFi"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const ESNetworkReachabilityDidChangeNotification;

FOUNDATION_EXTERN NSString *ESNetworkReachabilityStatusString(ESNetworkReachabilityStatus status);

/**
 * `ESNetworkReachability` monitors the network reachability for iOS and macOS.
 *
 * It is based on Apple's Reachability Sample Code ( https://developer.apple.com/library/ios/samplecode/reachability/ )
 */
@interface ESNetworkReachability : NSObject

/**
 * The shared instance for the default route.
 *
 * @see +reachabilityForInternetConnection
 */
+ (instancetype)defaultReachability;

/**
 * Initializes an `ESNetworkReachability` instance.
 */
- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability NS_DESIGNATED_INITIALIZER;

/**
 * Creates and returns an instance for the specified domain (host name).
 */
+ (instancetype)reachabilityWithDomain:(NSString *)domain;

/**
 * Creates and returns an instance for the specified socket address.
 *
 * @param address The socket address, `const struct sockaddr_in *` for IPv4, and `const struct sockaddr_in6 *` for IPv6.
 */
+ (instancetype)reachabilityWithAddress:(const void *)address;

/**
 * Creates and returns an instance for the default socket address (0.0.0.0), it supports both IPv4 and IPv6.
 */
+ (instancetype)reachabilityForInternetConnection;

/**
 * Creates and returns an instance for the local-only WiFi (Wi-Fi without a connection to the larger internet).
 * It actually monitor the `IN_LINKLOCALNETNUM` address which is 169.254.0.0.
 *
 * @note See the Apple documentation of "Removal of reachabilityForLocalWiFi": https://developer.apple.com/library/ios/samplecode/Reachability/Listings/ReadMe_md.html#//apple_ref/doc/uid/DTS40007324-ReadMe_md-DontLinkElementID_11
 * @note ONLY apps that have a specific requirement should be monitoring IN_LINKLOCALNETNUM.  For the overwhelming majority of apps, monitoring this address is unnecessary and potentially harmful.
 */
+ (instancetype)reachabilityForLocalWiFi;

/**
 * The identifier for this instance.
 *
 * It will be the domain or the address which currently monitors.
 */
@property (nonatomic, copy, nullable) NSString *identifier;

/**
 * The current network reachability status.
 */
- (ESNetworkReachabilityStatus)currentReachabilityStatus;

/**
 * The current network reachability status.
 */
- (NSString *)currentReachabilityStatusString;

/**
 * The current network reachability flags.
 */
- (SCNetworkReachabilityFlags)currentReachabilityFlags;

/**
 * Determines whether the network is currently reachable.
 */
- (BOOL)isReachable;

/**
 * Determines whether the network is currently reachable via WWAN.
 */
- (BOOL)isReachableViaWWAN;

/**
 * Determines whether the network is currently reachable via WiFi.
 */
- (BOOL)isReachableViaWiFi;

/**
 * Starts monitoring for changes in network reachability status.
 */
- (BOOL)startMonitoring;

/**
 * Stops monitoring for changes in network reachability status.
 */
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
