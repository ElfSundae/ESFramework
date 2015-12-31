//
//  ESAudioPlayer.h
//  ESFramework
//
//  Created by Elf Sundae on 7/18/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <ESFrameworkCore/ESFrameworkCore.h>
@class ESAudioPlayer;

typedef void (^ESAudioPlayerBlock)(ESAudioPlayer *player, NSURL *url);

/**
 * Audio player that handles correctly AVSession.
 */
@interface ESAudioPlayer : NSObject

//ES_SINGLETON_DEC(sharedPlayer);
//
//- (void)playWithURL:(NSURL *)url settings:(NSDictionary *)settings didFinishPlaying:(ESAudioPlayerBlock)didFinishPlaying;
//- (void)pause;
//- (void)stop;
//
//- (BOOL)isPlaying;
//- (NSTimeInterval)duration;


@end
