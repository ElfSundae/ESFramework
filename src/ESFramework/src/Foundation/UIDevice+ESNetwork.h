//
//  UIDevice+ESNetwork.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ESNetworkStatus) {
        ESNetworkStatusNotReachable,
        ESNetworkStatusViaWWAN,
        ESNetworkStatusViaWiFi
};

@interface UIDevice (ESNetwork)

+ (ESNetworkStatus)currentNetworkStatus;

@end
