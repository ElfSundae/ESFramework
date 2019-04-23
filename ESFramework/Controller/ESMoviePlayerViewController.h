//
//  ESMoviePlayerViewController.h
//  ESFramework
//
//  Created by Elf Sundae on 5/17/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

/**
 * A wrapper of `MPMoviePlayerViewController`, prevents MoviePlayer from dismissing when the
 * application enters background, and provides some features.
 */
@interface ESMoviePlayerViewController : MPMoviePlayerViewController

- (instancetype)initWithContentURL:(NSURL *)contentURL NS_DESIGNATED_INITIALIZER;
/// Presents ESMoviePlayerViewController from `[ESApp rootViewControllerForPresenting]`
- (void)presentWithAnimation:(BOOL)animated dismissedBlock:(void (^)(NSURL *contentURL, MPMovieFinishReason finishReason))dismissedBlock;
/// Dismiss ESMoviePlayerViewController
- (void)dismiss;

/// Default is NO, means only resume playing when the `playbackStateWhenAppResignActive` is `MPMoviePlaybackStatePlaying`
@property (nonatomic) BOOL forceResumePlayingWhenAppBecomeActive;
/// Default is YES
@property (nonatomic) BOOL autoDismissWhenPlaybackEnded;
/// Default is YES
@property (nonatomic) BOOL dismissWithAnimation;
/// Invoked when playerController is dismissed.
@property (nonatomic, copy) void (^dismissedBlock)(NSURL *contentURL, MPMovieFinishReason finishReason);

/// The default values is set to UIInterfaceOrientationMaskAll for the iPad idiom and UIInterfaceOrientationMaskAllButUpsideDown for the iPhone idiom.
@property (nonatomic) UIInterfaceOrientationMask supportedOrientations;
/// Default is [UIApplication sharedApplication].statusBarOrientation
@property (nonatomic) UIInterfaceOrientation preferredOrientationForPresentation;


@property (nonatomic, readonly) NSTimeInterval playbackTimeWhenAppResignActive;
@property (nonatomic, readonly) MPMoviePlaybackState playbackStateBeforeAppResignActive;

@end

#pragma clang diagnostic pop
