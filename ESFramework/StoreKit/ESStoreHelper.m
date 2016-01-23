//
//  ESITunesStoreHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 4/19/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESStoreHelper.h"
#import <ESFramework/NSString+ESAdditions.h>
#import <ESFramework/NSRegularExpression+ESAdditions.h>

@implementation ESStoreHelper

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

+ (NSURL *)appLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        if ([self isItemID:appID]) {
                NSString *countryCodeString = (ESIsStringWithAnyText(storeCountryCode) ?
                                               [storeCountryCode stringByAppendingString:@"/"] :
                                               @"");
                return [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/%@app/id%@",
                                             countryCodeString,
                                             appID]];
        }
        return nil;
}

+ (NSURL *)appStoreLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        if ([self isItemID:appID]) {
                NSString *countryCodeString = (ESIsStringWithAnyText(storeCountryCode) ?
                                               [storeCountryCode stringByAppendingString:@"/"] :
                                               @"");
                return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/%@app/id%@",
                                             countryCodeString,
                                             appID]];
        }
        return nil;
}

+ (NSURL *)appStoreReviewLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        if ([self isItemID:appID]) {
                NSString *countryCodeString = (ESIsStringWithAnyText(storeCountryCode) ?
                                               [storeCountryCode stringByAppendingString:@"/"] :
                                               @"");
                return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/%@WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                                             countryCodeString,
                                             appID]];
        }
        return nil;
}

+ (void)openAppStoreWithAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        NSURL *url = [self appStoreLinkForAppID:appID storeCountryCode:storeCountryCode];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
        }
}

+ (void)openAppStoreWithAppID:(NSString *)appID
{
        [self openAppStoreWithAppID:appID storeCountryCode:nil];
}

+ (void)openAppStoreReviewPageWithAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode
{
        NSURL *url = [self appStoreReviewLinkForAppID:appID storeCountryCode:storeCountryCode];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
        }
}

+ (void)openAppStoreReviewPageWithAppID:(NSString *)appID
{
        [self openAppStoreReviewPageWithAppID:appID storeCountryCode:nil];
}

@end