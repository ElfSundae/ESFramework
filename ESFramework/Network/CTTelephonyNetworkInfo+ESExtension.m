//
//  CTTelephonyNetworkInfo+ESExtension.m
//  ESFramework
//
//  Created by Elf Sundae on 2020/06/29.
//  Copyright © 2020 https://0x123.com. All rights reserved.
//

#import "CTTelephonyNetworkInfo+ESExtension.h"
#if TARGET_OS_IOS && !TARGET_OS_MACCATALYST

@implementation CTTelephonyNetworkInfo (ESExtension)

- (nullable CTCarrier *)dataServiceSubscriberCellularProvider
{
    if (@available(iOS 13, *)) {
        return self.serviceSubscriberCellularProviders[self.dataServiceIdentifier];
    } else {
        return self.subscriberCellularProvider;
    }
}

- (nullable NSString *)dataServiceCurrentRadioAccessTechnology
{
    if (@available(iOS 13, *)) {
        return self.serviceCurrentRadioAccessTechnology[self.dataServiceIdentifier];
    } else {
        return self.currentRadioAccessTechnology;
    }
}

@end

#endif
