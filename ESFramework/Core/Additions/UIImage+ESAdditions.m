//
//  UIImage+ESAdditions.m
//  ESFramework
//
//  Created by Elf Sundae on 14-4-8.
//  Copyright (c) 2014 www.0x123.com. All rights reserved.
//

#import "UIImage+ESAdditions.h"
#import "ESDefines.h"

@implementation UIImage (ESAdditions)

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
        CGRect rect = CGRectMake(0., 0., cornerRadius*2.+1., cornerRadius*2.+1.);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        path.lineWidth = 0.;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.);
        [color setFill];
        [path fill];
        [path stroke];
        [path addClip];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
        return image;
}

- (UIImage *)resizableImageWithMinimumSize:(CGSize)size
{
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.);
        [self drawInRect:rect];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(size.height / 2., size.width / 2., size.height / 2., size.width/ 2.)];
        return image;
}

/**
 * Returns true if the image has an alpha layer.
 */
- (BOOL)hasAlpha
{
        CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
        return (alpha == kCGImageAlphaFirst ||
                alpha == kCGImageAlphaLast ||
                alpha == kCGImageAlphaPremultipliedFirst ||
                alpha == kCGImageAlphaPremultipliedLast);
}

/**
 * Returns a copy of the given image, adding an alpha channel if it doesn't already have one.
 */
- (UIImage *)imageWithAlpha
{
        if ([self hasAlpha]) {
                return self;
        }
        
        CGFloat scale = MAX(self.scale, 1.0);
        CGImageRef imageRef = self.CGImage;
        size_t width = CGImageGetWidth(imageRef)*scale;
        size_t height = CGImageGetHeight(imageRef)*scale;
        
        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                              width,
                                                              height,
                                                              8,
                                                              0,
                                                              CGImageGetColorSpace(imageRef),
                                                              kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
        UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha scale:self.scale orientation:UIImageOrientationUp];
        
        // Clean up
        CGContextRelease(offscreenContext);
        CGImageRelease(imageRefWithAlpha);
        
        return imageWithAlpha;
}


- (UIImage *)croppedImage:(CGRect)bounds
{
        CGFloat scale = MAX(self.scale, 1.0);
        CGRect scaledBounds = CGRectMake(bounds.origin.x * scale, bounds.origin.y * scale, bounds.size.width * scale, bounds.size.height * scale);
        CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], scaledBounds);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
        CGImageRelease(imageRef);
        return croppedImage;
}

/**
 * Resizing using kCGInterpolationHigh quality.
 */
- (UIImage *)resizedImage:(CGSize)newSize
{
        return [self resizedImage:newSize interpolationQuality:kCGInterpolationHigh];
}


/**
 * Returns a rescaled copy of the image, taking into account its orientation.
 * The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter.
 */
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality
{
        BOOL drawTransposed;
        switch ( self.imageOrientation )
        {
                case UIImageOrientationLeft:
                case UIImageOrientationLeftMirrored:
                case UIImageOrientationRight:
                case UIImageOrientationRightMirrored:
                        drawTransposed = YES;
                        break;
                default:
                        drawTransposed = NO;
        }
        
        CGAffineTransform transform = [self transformForOrientation:newSize];
        
        return [self resizedImage:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
}


/**
 * Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size.
 * The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation.
 * If the new size is not integral, it will be rounded up.
 */
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality
{
        CGFloat scale = MAX(1.0, self.scale);
        CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width*scale, newSize.height*scale));
        CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
        CGImageRef imageRef = self.CGImage;
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef bitmap = CGBitmapContextCreate(
                                                    NULL,
                                                    newRect.size.width,
                                                    newRect.size.height,
                                                    8, /* bits per channel */
                                                    (newRect.size.width * 4), /* 4 channels per pixel * numPixels/row */
                                                    colorSpace,
                                                    (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                    );
        CGColorSpaceRelease(colorSpace);
	
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(bitmap, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, quality);
        
        // Draw into the context; this scales the image
        CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
        
        // Get the resized image from the context and a UIImage
        CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:UIImageOrientationUp];
        
        // Clean up
        CGContextRelease(bitmap);
        CGImageRelease(newImageRef);
        
        return newImage;
}

/**
 * Resizes the image according to the given content mode, taking into account the image's orientation.
 *
 * #contentMode supports UIViewContentModeScaleAspectFill, UIViewContentModeScaleAspectFit.
 */
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality
{
        CGFloat horizontalRatio = bounds.width / self.size.width;
        CGFloat verticalRatio = bounds.height / self.size.height;
        CGFloat ratio;
        
        switch (contentMode) {
                case UIViewContentModeScaleAspectFill:
                        ratio = MAX(horizontalRatio, verticalRatio);
                        break;
                        
                case UIViewContentModeScaleAspectFit:
                        ratio = MIN(horizontalRatio, verticalRatio);
                        break;
                        
                default:
                        [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long)contentMode];
        }
        
        CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
        
        return [self resizedImage:newSize interpolationQuality:quality];
}


/**
 * Returns a copy of this image that is squared to the thumbnail size.
 */
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize cornerRadius:(NSUInteger)cornerRadius interpolationQuality:(CGInterpolationQuality)quality
{
        
        UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                           bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                             interpolationQuality:quality];
        
        
        // Crop out any part of the image that's larger than the thumbnail size
        // The cropped rect must be centered on the resized image
        // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
        CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                     round((resizedImage.size.height - thumbnailSize) / 2),
                                     thumbnailSize,
                                     thumbnailSize);
        UIImage *croppedImage = [resizedImage croppedImage:cropRect];
        return [croppedImage roundedCornerImage:cornerRadius borderSize:0];
}

/**
 * Helper method.
 * Returns an affine transform that takes into account the image orientation when drawing a scaled image
 */
- (CGAffineTransform)transformForOrientation:(CGSize)newSize
{
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        switch (self.imageOrientation) {
                case UIImageOrientationDown:           // EXIF = 3
                case UIImageOrientationDownMirrored:   // EXIF = 4
                        transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
                        transform = CGAffineTransformRotate(transform, M_PI);
                        break;
                        
                case UIImageOrientationLeft:           // EXIF = 6
                case UIImageOrientationLeftMirrored:   // EXIF = 5
                        transform = CGAffineTransformTranslate(transform, newSize.width, 0);
                        transform = CGAffineTransformRotate(transform, M_PI_2);
                        break;
                        
                case UIImageOrientationRight:          // EXIF = 8
                case UIImageOrientationRightMirrored:  // EXIF = 7
                        transform = CGAffineTransformTranslate(transform, 0, newSize.height);
                        transform = CGAffineTransformRotate(transform, -M_PI_2);
                        break;
                default:
                        break;
        }
        
        switch (self.imageOrientation) {
                case UIImageOrientationUpMirrored:     // EXIF = 2
                case UIImageOrientationDownMirrored:   // EXIF = 4
                        transform = CGAffineTransformTranslate(transform, newSize.width, 0);
                        transform = CGAffineTransformScale(transform, -1, 1);
                        break;
                        
                case UIImageOrientationLeftMirrored:   // EXIF = 5
                case UIImageOrientationRightMirrored:  // EXIF = 7
                        transform = CGAffineTransformTranslate(transform, newSize.height, 0);
                        transform = CGAffineTransformScale(transform, -1, 1);
                        break;
                default:
                        break;
        }
        
        return transform;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Rounded Corner

/**
 * Adds a rectangular path to the given context and rounds its corners by the given extents.
 * Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/.
 */
- (void)addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight
{
        if (ovalWidth == 0 || ovalHeight == 0) {
                CGContextAddRect(context, rect);
                return;
        }
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, ovalWidth, ovalHeight);
        CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
        CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
        CGContextMoveToPoint(context, fw, fh/2);
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
        CGContextClosePath(context);
        CGContextRestoreGState(context);
}

/**
 * Creates a copy of this image with rounded corners
 * If borderSize is non-zero, a transparent border of the given size will also be added
 * Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize
{
        // If the image does not have an alpha layer, add one
        UIImage *image = [self imageWithAlpha];
        
        CGFloat scale = MAX(self.scale,1.0);
        NSUInteger scaledBorderSize = borderSize * scale;
        
        // Build a context that's the same dimensions as the new size
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     image.size.width*scale,
                                                     image.size.height*scale,
                                                     CGImageGetBitsPerComponent(image.CGImage),
                                                     0,
                                                     CGImageGetColorSpace(image.CGImage),
                                                     CGImageGetBitmapInfo(image.CGImage));
        
        // Create a clipping path with rounded corners
        
        CGContextBeginPath(context);
        [self addRoundedRectToPath:CGRectMake(scaledBorderSize, scaledBorderSize, image.size.width*scale - borderSize * 2, image.size.height*scale - borderSize * 2)
                           context:context
                         ovalWidth:cornerSize*scale
                        ovalHeight:cornerSize*scale];
        CGContextClosePath(context);
        CGContextClip(context);
        
        // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width*scale, image.size.height*scale), image.CGImage);
        
        // Create a CGImage from the context
        CGImageRef clippedImage = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        
        // Create a UIImage from the CGImage
        UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage scale:self.scale orientation:UIImageOrientationUp];
        
        CGImageRelease(clippedImage);
        
        return roundedImage;
}


@end
