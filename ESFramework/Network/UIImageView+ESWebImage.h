//
//  UIImageView+ESWebImage.h
//  ESFramework
//
//  Created by Elf Sundae on 5/22/14.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ESFrameworkCore/ESFrameworkCore.h>
#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

@interface UIImageView (ESWebImage)

- (void)downloadImageWithURL:(NSURL *)imageURL completed:(SDWebImageCompletedBlock)completedBlock;
- (void)downloadImageWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock;
- (void)cancelImageDownloading;

- (void)setImageAnimatedWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder;
- (void)setImageAnimatedWithURL:(NSURL *)imageURL placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock;

@end
