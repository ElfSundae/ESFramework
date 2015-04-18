//
//  ESITunesStoreHelper.m
//  ESFramework
//
//  Created by Elf Sundae on 4/19/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import "ESITunesStoreHelper.h"
#import "ESDefines.h"
#import "NSString+ESAdditions.h"
#import "NSRegularExpression+ESAdditions.h"

@implementation ESITunesStoreHelper

+ (NSString *)iTunesItemIDFromURL:(NSString *)iTunesLink
{
        if (ESIsStringWithAnyText(iTunesLink)) {
                NSRegularExpression *regex = [NSRegularExpression regex:@"://itunes\\.apple\\.com/.+/id(\\d{8,})" caseInsensitive:YES];
                NSTextCheckingResult *match = [regex firstMatchInString:iTunesLink];
                if (match && match.numberOfRanges > 1) {
                        return [iTunesLink substringWithRange:[match rangeAtIndex:1]];
                }
        }
        return nil;
}

+ (BOOL)isITunesItemID:(NSString *)itemID
{
        return (ESIsStringWithAnyText(itemID) && [itemID isMatch:@"^\\d{8,}$"]); 
}

+ (NSString *)appLinkForAppID:(NSString *)appID
{
        if ([self isITunesItemID:appID]) {
                return NSStringWith(@"https://itunes.apple.com/app/id%@", appID);
        }
        return nil;
}

+ (NSString *)appStoreLinkForAppID:(NSString *)appID
{
        if ([self isITunesItemID:appID]) {
                return NSStringWith(@"itms-apps://itunes.apple.com/app/id%@", appID);
        }
        return nil;
}

+ (NSString *)appStoreReviewLinkForAppID:(NSString *)appID
{
        if ([self isITunesItemID:appID]) {
                return NSStringWith(@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID);
        }
        return nil;
}

@end
