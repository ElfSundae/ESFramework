//
//  ESITunesStoreHelper.h
//  ESFramework
//
//  Created by Elf Sundae on 4/19/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESITunesStoreHelper : NSObject

/**
 * Returns the iTunes item identifier(ID) from the iTunes Store URL, returns `nil` if parsing failed.
 * All types of iTunes link are supported, include scheme http[s], itms, itms-apps, etc.
 *
 * e.g. The url https://itunes.apple.com/us/app/qq-cai-xin/id520005183?mt=8 will get @"520005183".
 *
 * Supports all type iTunes links like Apps, Books, Music, Music Videos, Audio Book, Podcast, Movie, etc.
 */
+ (NSString *)iTunesItemIDFromURL:(NSString *)iTunesLink;

/**
 * Item ID matches "^\d{8,}$".
 */
+ (BOOL)isITunesItemID:(NSString *)itemID;

/**
 * e.g. @"12345678" to @"https://itunes.apple.com/app/id12345678"
 */
+ (NSString *)appLinkForAppID:(NSString *)appID;

/**
 * e.g. @"12345678" to @"itms-apps://itunes.apple.com/app/id12345678"
 */
+ (NSString *)appStoreLinkForAppID:(NSString *)appID;

/**
 * e.g. @"12345678" to @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=12345678"
 */
+ (NSString *)appStoreReviewLinkForAppID:(NSString *)appID;


@end
