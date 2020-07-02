//
//  CTTelephonyNetworkInfo+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2020/06/29.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import "CTTelephonyNetworkInfo+ESExtension.h"
#if TARGET_OS_IOS

@import CoreTelephony; // To auto-link CoreTelephony framework, fix build error on Mac Catalyst

@implementation CTTelephonyNetworkInfo (ESExtension)

- (nullable CTCarrier *)dataServiceSubscriberCellularProvider
{
#if TARGET_OS_MACCATALYST
    return self.serviceSubscriberCellularProviders[self.dataServiceIdentifier];
#else
    if (@available(iOS 13, *)) {
        return self.serviceSubscriberCellularProviders[self.dataServiceIdentifier];
    } else {
        return self.subscriberCellularProvider;
    }
#endif
}

- (nullable NSString *)dataServiceCurrentRadioAccessTechnology
{
#if TARGET_OS_MACCATALYST
    return self.serviceCurrentRadioAccessTechnology[self.dataServiceIdentifier];
#else
    if (@available(iOS 13, *)) {
        return self.serviceCurrentRadioAccessTechnology[self.dataServiceIdentifier];
    } else {
        return self.currentRadioAccessTechnology;
    }
#endif
}

@end

#endif
