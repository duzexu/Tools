//
//  NAPhoto.h
//  ZoomingScrollView
//
//  Created by Michael Waterfall on 04/11/2009.
//  Copyright 2009 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>

// Class
@class NAPhoto;

// Delegate
@protocol NAPhotoDelegate <NSObject>
- (void)photoDidFinishLoading:(NAPhoto *)photo;
- (void)photoDidFailToLoad:(NAPhoto *)photo;
@end

@interface NAPhoto : NSObject {
    // Image
	NSString *photoPath;
	NSURL *photoURL;
	UIImage *photoImage;
	
	// Flags
	BOOL workingInBackground;
}


// Class
+ (NAPhoto *)photoWithImage:(UIImage *)image;
+ (NAPhoto *)photoWithFilePath:(NSString *)path;
+ (NAPhoto *)photoWithURL:(NSURL *)url;

// Init
- (id)initWithImage:(UIImage *)image;
- (id)initWithFilePath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;

// Public methods
- (BOOL)isImageAvailable;
- (UIImage *)image;
- (UIImage *)obtainImage;
- (void)obtainImageInBackgroundAndNotify:(id <NAPhotoDelegate>)notifyDelegate;
- (void)releasePhoto;


@end
