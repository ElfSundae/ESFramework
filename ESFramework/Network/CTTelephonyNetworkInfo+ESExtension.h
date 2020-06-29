//
//  CTTelephonyNetworkInfo+ESExtension.h
//  ESFramework
//
//  Created by Elf Sundae on 2020/06/29.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTTelephonyNetworkInfo (ESExtension)

/**
 * A CTCarrier object that contains information about the subscriber's home
 * cellular service provider for the service that's currently providing data.
 */
- (nullable CTCarrier *)dataServiceSubscriberCellularProvider;

/**
 * The current radio access technology for the service that's currently
 * providing data. May be nil if the device is not registered on any network.
 */
- (nullable NSString *)dataServiceCurrentRadioAccessTechnology;

@end

NS_ASSUME_NONNULL_END

#endif
