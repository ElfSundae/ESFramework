//
//  UIImageView+ESWebImage.m
//  ESFramework
//
//  Created by Elf Sundae on 5/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIImageView+ESWebImage.h"

static const void *_esImageDownloadOperationKey = &_esImageDownloadOperationKey;

@implementation UIImageView (ESWebImage)

- (void)downloadImageWithURL:(NSURL *)imageURL completed:(SDWebImageCompletedBlock)completedBlock
{
        [self downloadImageWithURL:imageURL placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)downloadImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock
{
        [self cancelImageDownloading];
        
        self.image = placeholder;
        if ([imageURL isKindOfClass:[NSURL class]]) {
                ES_WEAK_VAR(self, weakSelf);
                id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadWithURL:imageURL options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                        ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                        ESDispatchSyncOnMainThread(^{
                                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                                if (completedBlock && finished) {
                                        completedBlock(image, error, cacheType);
                                }
                        });
                }];
                [self setAssociatedObject_nonatomic_retain:operation key:_esImageDownloadOperationKey];
        }
}

- (void)cancelImageDownloading
{
        id<SDWebImageOperation> operation = [self getAssociatedObject:_esImageDownloadOperationKey];
        if (operation) {
                [operation cancel];
                [self setAssociatedObject_nonatomic_retain:nil key:_esImageDownloadOperationKey];
        }
}

- (void)setImageAnimatedWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder
{
        [self setImageAnimatedWithURL:imageURL placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageAnimatedWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock
{
        ES_WEAK_VAR(self, weakSelf);
        [self downloadImageWithURL:imageURL placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                ES_STRONG_VAR_CHECK_NULL(weakSelf, _self);
                if (image) {
                        [_self setImageAnimated:image];
                        [_self setNeedsLayout];
                }
                if (completedBlock) {
                        completedBlock(image, error, cacheType);
                }
        }];
}

@end
