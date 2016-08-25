//
//  ESNetworkReachability.m
//  ESFramework
//
//  Created by Elf Sundae on 2016/08/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import "ESNetworkReachability.h"

NSString *const ESNetworkReachabilityDidChangeNotification = @"ESNetworkReachabilityDidChangeNotification";

static void ESNetworkReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info);

@interface ESNetworkReachability ()
@property (nonatomic, assign, readonly) SCNetworkReachabilityRef networkReachability;
@property (nonatomic, strong) dispatch_queue_t networkReachabilityQueue;
@end

@implementation ESNetworkReachability

- (void)dealloc
{
    [self stopMonitoring];

    if (_networkReachability) {
        CFRelease(_networkReachability);
        _networkReachability = NULL;
    }
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability
{
    self = [super init];
    if (self) {
        _networkReachability = CFRetain(reachability);

        NSString *queueName = [NSString stringWithFormat:@"com.0x123.ESNetworkReachability.%@", [NSUUID UUID].UUIDString];
        self.networkReachabilityQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    }

    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

+ (instancetype)defaultReachability
{
    static ESNetworkReachability *__gDefaultReachability = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __gDefaultReachability = [self reachabilityForInternetConnection];
    });

    return __gDefaultReachability;
}

+ (instancetype)reachabilityWithDomain:(NSString *)domain
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [domain UTF8String]);

    ESNetworkReachability *instance = [[self alloc] initWithReachability:reachability];

    CFRelease(reachability);

    return instance;
}

+ (instancetype)reachabilityWithAddress:(const void *)address
{
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(NULL, (const struct sockaddr *)address);

    ESNetworkReachability *instance = [[self alloc] initWithReachability:reachability];

    CFRelease(reachability);

    return instance;
}

+ (instancetype)reachabilityForInternetConnection
{
#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    struct sockaddr_in6 address;
    bzero(&address, sizeof(address));
    address.sin6_len = sizeof(address);
    address.sin6_family = AF_INET6;
#else
    struct sockaddr_in address;
    bzero(&address, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
#endif

    return [self reachabilityWithAddress:&address];
}

+ (instancetype)reachabilityForLocalWiFi
{
    struct sockaddr_in localWifiAddress;
    bzero(&localWifiAddress, sizeof(localWifiAddress));
    localWifiAddress.sin_len = sizeof(localWifiAddress);
    localWifiAddress.sin_family = AF_INET;
    // IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
    localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);

    return [self reachabilityWithAddress:&localWifiAddress];
}

- (ESNetworkReachabilityStatus)currentReachabilityStatus
{
    return [[self class] statusForReachabilityFlags:self.currentReachabilityFlags];
}

- (NSString *)currentReachabilityStatusString
{
    return ESNetworkReachabilityStatusString(self.currentReachabilityStatus);
}

- (SCNetworkReachabilityFlags)currentReachabilityFlags
{
    if (self.networkReachability) {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.networkReachability, &flags)) {
            return flags;
        }
    }

    return 0;
}

- (BOOL)isReachable
{
    return (ESNetworkReachabilityStatusNotReachable != self.currentReachabilityStatus);
}

- (BOOL)isReachableViaWWAN
{
    return (ESNetworkReachabilityStatusReachableViaWWAN == self.currentReachabilityStatus);
}

- (BOOL)isReachableViaWiFi
{
    return (ESNetworkReachabilityStatusReachableViaWiFi == self.currentReachabilityStatus);
}

- (BOOL)startMonitoring
{
    [self stopMonitoring];

    if (self.networkReachability) {
        SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};

        if (SCNetworkReachabilitySetCallback(self.networkReachability, ESNetworkReachabilityCallback, &context)) {
            if (SCNetworkReachabilitySetDispatchQueue(self.networkReachability, self.networkReachabilityQueue)) {
                return YES;
            } else {
                SCNetworkReachabilitySetCallback(self.networkReachability, NULL, NULL);
            }
        }
    }

    return NO;
}

- (void)stopMonitoring
{
    if (self.networkReachability) {
        SCNetworkReachabilitySetCallback(self.networkReachability, NULL, NULL);
        SCNetworkReachabilitySetDispatchQueue(self.networkReachability, NULL);
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, flags: %@, status: %@>",
            NSStringFromClass([self class]),
            self,
            [[self class] networkReachabilityFlagsString:self.currentReachabilityFlags],
            self.currentReachabilityStatusString
    ];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)networkReachabilityStatusChanged:(SCNetworkReachabilityFlags)flags
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ESNetworkReachabilityDidChangeNotification object:self];
    });
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Helpers

+ (NSString *)networkReachabilityFlagsString:(SCNetworkReachabilityFlags)flags
{
    return [NSString stringWithFormat:@"%c%c %c%c%c%c%c%c%c",
#if TARGET_OS_IPHONE
            (flags & kSCNetworkReachabilityFlagsIsWWAN) ? 'W' : '-',
#else
            'X',
#endif
            (flags & kSCNetworkReachabilityFlagsReachable) ? 'R' : '-',
            (flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionRequired) ? 'c' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-',
            (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
            (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ? 'D' : '-',
            (flags & kSCNetworkReachabilityFlagsIsLocalAddress) ? 'l' : '-',
            (flags & kSCNetworkReachabilityFlagsIsDirect) ? 'd' : '-'
    ];
}

+ (ESNetworkReachabilityStatus)statusForReachabilityFlags:(SCNetworkReachabilityFlags)flags
{
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    // the connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs...
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    // and no [user] intervention is needed...
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);

    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));

    if (!isNetworkReachable) {
        return ESNetworkReachabilityStatusNotReachable;
    }
#if TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        return ESNetworkReachabilityStatusReachableViaWWAN;
    }
#endif
    else {
        return ESNetworkReachabilityStatusReachableViaWiFi;
    }
}

@end

NSString *ESNetworkReachabilityStatusString(ESNetworkReachabilityStatus status)
{
    switch (status) {
        case ESNetworkReachabilityStatusNotReachable:
            return ESNetworkReachabilityStatusStringNotReachable;

        case ESNetworkReachabilityStatusReachableViaWWAN:
            return ESNetworkReachabilityStatusStringReachableViaWWAN;

        case ESNetworkReachabilityStatusReachableViaWiFi:
            return ESNetworkReachabilityStatusStringReachableViaWiFi;

        default:
            return @"Unknown";
    }
}

static void ESNetworkReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
#pragma unused (target)
    ESNetworkReachability *instance = (__bridge ESNetworkReachability *)info;

    @autoreleasepool {
        [instance networkReachabilityStatusChanged:flags];
    }
}