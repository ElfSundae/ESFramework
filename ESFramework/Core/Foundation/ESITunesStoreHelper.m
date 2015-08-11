//
//  ESITunesStoreHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 4/19/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESITunesStoreHelper.h"
#import "NSString+ESAdditions.h"
#import "NSRegularExpression+ESAdditions.h"
#import "ESApp.h"


NSString *const ESITunesStoreCountryCodeChina           = @"cn";
NSString *const ESITunesStoreCountryCodeUnitedStates    = @"us";


@implementation ESITunesStoreHelper

+ (NSString *)itemIDFromURL:(NSURL *)URL
{
        NSString *urlString = URL.absoluteString;
        if (ESIsStringWithAnyText(urlString)) {
                NSRegularExpression *regex = [NSRegularExpression regex:@"://itunes\\.apple\\.com/.+/id(\\d{8,})" caseInsensitive:YES];
                NSTextCheckingResult *match = [regex firstMatchInString:urlString];
                if (match && match.numberOfRanges > 1) {
                        return [urlString substringWithRange:[match rangeAtIndex:1]];
                }
        }
        return nil;
}

+ (BOOL)isItemID:(NSString *)itemID
{
        return (ESIsStringWithAnyText(itemID) && [itemID isMatch:@"^\\d{8,}$"]); 
}

+ (NSString *)appLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        if ([self isItemID:appID]) {
                return NSStringWith(@"https://itunes.apple.com/%@app/id%@",
                                    (storeCountryCode.isEmpty ? @"" : NSStringWith(@"%@/", storeCountryCode)), appID);
        }
        return nil;
}

+ (NSString *)appStoreLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        if ([self isItemID:appID]) {
                return NSStringWith(@"itms-apps://itunes.apple.com/%@app/id%@",
                                    (storeCountryCode.isEmpty ? @"" : NSStringWith(@"%@/", storeCountryCode)), appID);
        }
        return nil;
}

+ (NSString *)appStoreReviewLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        if ([self isItemID:appID]) {
                return NSStringWith(@"itms-apps://itunes.apple.com/%@WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                                    (storeCountryCode.isEmpty ? @"" : NSStringWith(@"%@/", storeCountryCode)), appID);
        }
        return nil;
}

+ (void)openAppStoreWithAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        NSString *url = [self appStoreLinkForAppID:appID storeCountryCode:storeCountryCode];
        [ESApp openURLWithString:url];
}
+ (void)openAppStoreWithAppID:(NSString *)appID
{
        [self openAppStoreWithAppID:appID storeCountryCode:nil];
}
+ (void)openAppStoreReviewPageWithAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        NSString *url = [self appStoreReviewLinkForAppID:appID storeCountryCode:storeCountryCode];
        [ESApp openURLWithString:url];
}
+ (void)openAppStoreReviewPageWithAppID:(NSString *)appID
{
        [self openAppStoreReviewPageWithAppID:appID storeCountryCode:nil];
}


@end
