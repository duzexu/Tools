//
//  UIImage+Compress.m
//  test
//
//  Created by duzexu on 16/3/21.
//  Copyright © 2016年 duzexu. All rights reserved.
//

#import "UIImage+Compress.h"
#import <ImageIO/ImageIO.h>

static CGFloat const kDefaultCompressQuality = 0.85;

@implementation UIImage (Compress)

- (NSData *)compress {
    return [self compressWithQuality:kDefaultCompressQuality];
}

- (NSData *)compressWithQuality:(CGFloat)quality {
    // Create the image source (from path)
    //CGImageSourceRef src = CGImageSourceCreateWithURL((__bridge CFURLRef) [NSURL fileURLWithPath:imagePath], NULL);
    
    // To create image source from UIImage, use this
    NSData* pngData =  UIImagePNGRepresentation(self);
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)pngData, NULL);
    
    // Create thumbnail options
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @([UIScreen mainScreen].bounds.size.height*[UIScreen mainScreen].scale)
                                                           };
    // Generate the thumbnail
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options);
    if (!thumbnail) {
        return nil;
    }
    UIImage *result = [UIImage imageWithCGImage:thumbnail];
    CFRelease(src);
    CFRelease(thumbnail);
    //
    return UIImageJPEGRepresentation(result, quality);;
}

- (NSData *)compressToTargetSize:(NSUInteger)targetSize {
    CGFloat ratio = 1.0;
    CGFloat quality = 1.0;
    UIImage *result = nil;
    NSData *data = UIImageJPEGRepresentation(self, quality);
    while (data.length > targetSize) {
        if (ratio > quality) {
            ratio -= 0.1;
            result = [self scale:ratio];
        }else{
            quality -= 0.1;
            data = UIImageJPEGRepresentation(result, quality);
        }
    }
    return data;
}

- (UIImage *)scale:(CGFloat)scale {
    CGSize originalSize = self.size;
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

@end
