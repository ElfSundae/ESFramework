//
//  ESApp+Subclassing.m
//  ESFramework
//
//  Created by Elf Sundae on 1/21/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESApp.h"

ES_CATEGORY_FIX(ESApp_Subclassing)

@implementation ESApp (Subclassing)

- (NSString *)appChannel
{
        return @"App Store";
}

- (NSString *)appStoreID
{
        return nil;
}

- (NSTimeZone *)appWebServerTimeZone
{
        return [NSTimeZone timeZoneWithName:@"GMT"];
}

@end
