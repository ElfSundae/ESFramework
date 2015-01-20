//
//  ESAudioInternalPlayer.h
//  ESFramework
//
//  Created by Elf Sundae on 7/18/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <ESFrameworkCore/ESFrameworkCore.h>

@protocol ESAudioInternalPlayerDelegate;

/**
 * ESAudioInternalPlayer Protocol
 */
@protocol ESAudioInternalPlayer <NSObject>

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)error;

/** get ready to play the sound. happens automatically on play. */
- (BOOL)prepareToPlay;
/** sound is played asynchronously. */
- (BOOL)play;
/** stops playback. no longer ready to play. */
- (void)stop;

@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, readonly, getter = isPlaying) BOOL playing;
@property (nonatomic, readonly) NSTimeInterval duration;

/** The volume for the sound. The nominal range is from 0.0 to 1.0. */
@property (nonatomic) float volume;

@property (nonatomic, weak) __weak id<ESAudioInternalPlayerDelegate> delegate;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ESAudioInternalPlayerDelegate


@protocol ESAudioInternalPlayerDelegate <NSObject>
- (void)audioInternalPlayerDidFinishPlaying:(id<ESAudioInternalPlayer>)player successfully:(BOOL)flag;
- (void)audioInternalPlayerDecodeErrorDidOccur:(id<ESAudioInternalPlayer>)player error:(NSError *)error;
@end

