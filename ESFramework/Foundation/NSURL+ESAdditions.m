//
//  NSURL+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "NSURL+ESAdditions.h"
#import "NSURLComponents+ESAdditions.h"

@implementation NSURL (ESAdditions)

- (NSDictionary<NSString *, id> *)queryDictionary
{
    return [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES].queryItemsDictionary;
}

- (NSURL *)URLByAddingQueryDictionary:(NSDictionary<NSString *, id> *)queryDictionary
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:YES];
    [urlComponents addQueryItemsDictionary:queryDictionary];
    return urlComponents.URL;
}

+ (NSURL *)appLinkWithIdentifier:(NSInteger)appIdentifier
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/app/id%ld?mt=8", (long)appIdentifier]];
}

+ (NSURL *)appStoreLinkWithIdentifier:(NSInteger)appIdentifier
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%ld", (long)appIdentifier]];
}

+ (NSURL *)appStoreReviewLinkWithIdentifier:(NSInteger)appIdentifier
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%ld", (long)appIdentifier]];
}

@end
