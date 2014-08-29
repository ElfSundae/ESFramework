//
//  UIImage+ESAdditions.h
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 * @see http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
 * @see https://github.com/mbcharbonneau/UIImage-Categories
 */
@interface UIImage (ESAdditions)

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
- (UIImage *)resizableImageWithMinimumSize:(CGSize)size;

/**
 * Returns true if the image has an alpha layer.
 */
- (BOOL)hasAlpha;
/**
 * Returns a copy of the given image, adding an alpha channel if it doesn't already have one.
 */
- (UIImage *)imageWithAlpha;


/** 
 * Returns a copy of this image that is cropped to the given bounds.
 * The bounds will be adjusted using CGRectIntegral.
 * This method ignores the image's imageOrientation setting.
 */
- (UIImage *)croppedImage:(CGRect)bounds;

/**
 * Resizing using kCGInterpolationHigh quality.
 */
- (UIImage *)resizedImage:(CGSize)newSize;
/**
 * Returns a rescaled copy of the image, taking into account its orientation.
 * The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter.
 */
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

/**
 * Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size.
 * The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation.
 * If the new size is not integral, it will be rounded up.
 */
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality;

/**
 * Resizes the image according to the given content mode, taking into account the image's orientation.
 *
 * #contentMode supports UIViewContentModeScaleAspectFill, UIViewContentModeScaleAspectFit.
 */
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

/**
 * Returns a copy of this image that is squared to the thumbnail size.
 */
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;


/**
 * Helper method. 
 * Returns an affine transform that takes into account the image orientation when drawing a scaled image
 */
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

/**
 * Adds a rectangular path to the given context and rounds its corners by the given extents.
 * Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/.
 */
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight;
/**
 * Creates a copy of this image with rounded corners
 * If borderSize is non-zero, a transparent border of the given size will also be added
 * Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;



@end
