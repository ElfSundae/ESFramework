//
//  ESMoviePlayerViewController.m
//  ESFramework
//
//  Created by Elf Sundae on 5/17/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "ESMoviePlayerViewController.h"
#import "ESApp.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"

@interface ESMoviePlayerViewController ()
@property (nonatomic) NSTimeInterval playbackTimeWhenAppResignActive;
@property (nonatomic) MPMoviePlaybackState playbackStateBeforeAppResignActive;
@end

@implementation ESMoviePlayerViewController

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithContentURL:(NSURL *)contentURL
{
        self = [super initWithContentURL:contentURL];
        if (self) {
                self.forceResumePlayingWhenAppBecomeActive = NO;
                self.autoDismissWhenPlaybackEnded = YES;
                self.dismissWithAnimation = YES;
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                        self.supportedOrientations = UIInterfaceOrientationMaskAll;
                } else {
                        self.supportedOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
                }
                self.preferredOrientationForPresentation = [UIApplication sharedApplication].statusBarOrientation;
        }
        return self;
}

- (void)viewDidLoad
{
        [super viewDidLoad];
        
        NSNotificationCenter *notifier = [NSNotificationCenter defaultCenter];
        // Remove old implementation to prevent MoviePlayer from dismissing when application enters background.
        [notifier removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        // Remove old implementation to prevent MoviePlayer from dismissing when playback finish.
        [notifier removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        [notifier addObserver:self selector:@selector(es_applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        [notifier addObserver:self selector:@selector(es_applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [notifier addObserver:self selector:@selector(es_moviePlayerPlaybackDidFinishNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)presentWithAnimation:(BOOL)animated dismissedBlock:(void (^)(NSURL *contentURL, MPMovieFinishReason finishReason))dismissedBlock
{
        self.dismissedBlock = dismissedBlock;
        [[ESApp rootViewControllerForPresenting] presentViewController:self animated:animated completion:nil];
}

- (void)dismiss
{
        NSURL *contentURL = self.moviePlayer.contentURL;
        MPMovieFinishReason finishedReason = (MPMovieFinishReason)-1;
        void (^dismissedBlock)(NSURL *, MPMovieFinishReason) = [self.dismissedBlock copy];
        [self.presentingViewController dismissViewControllerAnimated:self.dismissWithAnimation completion:^{
                if (dismissedBlock) {
                        dismissedBlock(contentURL, finishedReason);
                }
        }];

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notification Handler

- (void)es_moviePlayerPlaybackDidFinishNotification:(NSNotification *)notification
{
        if (notification.object != self.moviePlayer) {
                return;
        }
        
        MPMovieFinishReason finishedReason = (MPMovieFinishReason)[notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
        BOOL shouldDismiss = YES;
        if (MPMovieFinishReasonPlaybackEnded == finishedReason && !self.autoDismissWhenPlaybackEnded) {
                shouldDismiss = NO;
        }
        
        if (shouldDismiss) {
                NSURL *contentURL = self.moviePlayer.contentURL;
                void (^dismissedBlock)(NSURL *, MPMovieFinishReason) = [self.dismissedBlock copy];
                [self.presentingViewController dismissViewControllerAnimated:self.dismissWithAnimation completion:^{
                        if (dismissedBlock) {
                                dismissedBlock(contentURL, finishedReason);
                        }
                }];
        }
}

- (void)es_applicationWillResignActiveNotification:(NSNotification *)notification
{
        self.playbackStateBeforeAppResignActive = self.moviePlayer.playbackState;
        // 先记录时间再暂停，这样在继续播放时会先向前移一点时间(seeking backward)，用户体验比较好
        self.playbackTimeWhenAppResignActive = self.moviePlayer.currentPlaybackTime;
        
        [self.moviePlayer pause];
}

- (void)es_applicationDidBecomeActiveNotification:(NSNotification *)notification
{
        BOOL autoPlay = NO;
        if (self.forceResumePlayingWhenAppBecomeActive ||
            (MPMoviePlaybackStatePlaying == self.playbackStateBeforeAppResignActive)) {
                autoPlay = YES;
        }
        
        self.moviePlayer.currentPlaybackTime = self.playbackTimeWhenAppResignActive;
        if (autoPlay) {
                self.moviePlayer.currentPlaybackRate = 1.;
        }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Orientation

- (BOOL)shouldAutorotate
{
        return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_4
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#else
- (NSUInteger)supportedInterfaceOrientations
#endif
{
        return self.supportedOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
        return self.preferredOrientationForPresentation;
}

@end

#pragma clang diagnostic pop
