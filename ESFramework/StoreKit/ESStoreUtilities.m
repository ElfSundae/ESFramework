//
//  ESStoreUtilities.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESStoreUtilities.h"
#import "ESApp.h"

@implementation ESStoreUtilities

+ (NSString *)itemIDFromITunesLink:(NSURL *)url
{
        NSString *string = url.absoluteString;
        if (!string) {
                return nil;
        }
        
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"://itunes.apple.com/.*/id(\\d{8,})\\D" options:NSRegularExpressionCaseInsensitive error:NULL];
        NSTextCheckingResult *match = [reg firstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        if (match) {
                return [string substringWithRange:[match rangeAtIndex:1]];
        }
        return nil;
}

+ (void)openReviewPageWithAppID:(NSString *)appID
{
        if (![appID isKindOfClass:[NSString class]] ||
            appID.length < 8) {
                return;
        }
        NSString *reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
        [ESApp openURLWithString:reviewURL];
}

+ (void)openReviewPageWithAppStoreURL:(NSURL *)url
{
        [self openReviewPageWithAppID:[self itemIDFromITunesLink:url]];
}

@end
