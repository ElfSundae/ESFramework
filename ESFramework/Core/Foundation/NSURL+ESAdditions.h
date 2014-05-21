//
//  NSURL+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-13.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ESAdditions)
/**
 * Parse query string to dictionary.
 */
- (NSDictionary *)queryDictionary;

/**
 * Returns the iTunes item identifier(ID) from the iTunes Store URL, returns `nil` if parsing failed.
 * All types of iTunes link are supported, include scheme http[s], itms, itms-apps, etc.
 *
 * e.g. The url https://itunes.apple.com/us/app/qq-cai-xin/id520005183?mt=8 will get @"520005183".
 *
 * Supports all type iTunes links like Apps, Books, Music, Music Videos, Audio Book, Podcast, Movie, etc.
 */
- (NSString *)iTunesItemID;

- (BOOL)isEqualToURL:(NSURL *)anotherURL;

@end
