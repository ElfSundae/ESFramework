//
//  ESITunesStoreHelper.h
//  ESFramework
//
//  Created by Elf Sundae on 4/19/15.
//  Copyright (c) 2015 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESDefines.h"

// TODO: add all countries code
ES_EXTERN NSString *const ESITunesStoreCountryCodeChina;        // "cn"
ES_EXTERN NSString *const ESITunesStoreCountryCodeUnitedStates; // "us"

/**
 * @see https://linkmaker.itunes.apple.com
 */
@interface ESITunesStoreHelper : NSObject

/**
 * Returns the iTunes item identifier(ID) from the iTunes Store URL, returns `nil` if parsing failed.
 * All types of iTunes link are supported, include scheme http[s], itms, itms-apps, etc.
 *
 * e.g. The url https://itunes.apple.com/us/app/facebook/id284882215?mt=8&ign-mpt=uo%3D4 will get @"284882215".
 *
 * Supports all type iTunes links like Apps, Books, Music, Music Videos, Audio Book, Podcast, Movie, etc.
 */
+ (NSString *)itemIDFromURL:(NSURL *)URL;

/**
 * Item ID matches "^\d{8,}$".
 */
+ (BOOL)isItemID:(NSString *)itemID;

/**
 * e.g. @"284882215", @"us": to @"https://itunes.apple.com/us/app/id284882215"
 * `storeCountryCode` can be nil.
 */
+ (NSString *)appLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode;

/**
 * e.g. @"284882215", @"us": to @"itms-apps://itunes.apple.com/us/app/id284882215"
 * `storeCountryCode` can be nil.
 */
+ (NSString *)appStoreLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode;

/**
 * e.g. @"284882215" to @"itms-apps://itunes.apple.com/us/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=284882215"
 * `storeCountryCode` can be nil.
 */
+ (NSString *)appStoreReviewLinkForAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode;


+ (void)openAppStoreWithAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode;
+ (void)openAppStoreWithAppID:(NSString *)appID;
+ (void)openAppStoreReviewPageWithAppID:(NSString *)appID storeCountryCode:(NSString *)storeCountryCode;
+ (void)openAppStoreReviewPageWithAppID:(NSString *)appID;


@end
