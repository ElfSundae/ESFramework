//
//  ESStoreUtilities.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-10.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ESStoreUtilities : NSObject

/**
 * Returns the iTunes item identifier from the iTunes Store URL, nil if parsed failed.
 * All types of iTunes link are supported, include scheme http[s], itms, itms-apps, etc.
 *
 * e.g. The url https://itunes.apple.com/us/app/qq-cai-xin/id520005183?mt=8
 * will get @"520005183"
 *
 * Supports all type iTunes links like Apps, Books, Music, Music Videos, 
 * Audio Book, Podcast, Movie, etc.
 */
+ (NSString *)itemIDFromITunesLink:(NSURL *)url;


/**
 * Open App Store, and goto the Review page.
 */
+ (void)openReviewPageWithAppID:(NSString *)appID;
+ (void)openReviewPageWithAppStoreURL:(NSURL *)url;

@end
