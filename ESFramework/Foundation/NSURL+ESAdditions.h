//
//  NSURL+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (ESAdditions)

/**
 * Returns the query components parsed to a dictionary for this URL.
 *
 * @discussion For URL http://foo.bar?key=value&arr[]=value&arr[]=value1 , the query component will be:
 * { key:value, arr:[value, value1] }.
 */
- (nullable NSDictionary<NSString *, id> *)queryDictionary;

/**
 * Returns a newly created URL added the given query dictionary.
 */
- (NSURL *)URLByAddingQueryDictionary:(NSDictionary<NSString *, id> *)queryDictionary;

/**
 * e.g. "https://itunes.apple.com/app/id12345678?mt=8"
 */
+ (NSURL *)appLinkWithIdentifier:(NSInteger)appIdentifier;

/**
 * e.g. "itms-apps://itunes.apple.com/app/id12345678"
 */
+ (NSURL *)appStoreLinkWithIdentifier:(NSInteger)appIdentifier;

/**
 * e.g. "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=12345678"
 */
+ (NSURL *)appStoreReviewLinkWithIdentifier:(NSInteger)appIdentifier;

@end

NS_ASSUME_NONNULL_END
