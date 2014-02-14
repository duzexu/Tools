//
//  UIImageView+UIImageView_FaceAwareFill.h
//  faceAwarenessClipping
//
//  Created by Julio Andrés Carrettoni on 03/02/13.
//  Copyright (c) 2013 Julio Andrés Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (UIImageView_FaceAwareFill)

//Ask the image to perform an "Aspect Fill" but centering the image to the detected faces
//Not the simple center of the image
/**
 *  可以自动根据图像内容进行调整，当检测到人脸时，它会以脸部中心替代掉以图片的几何中心
 */
- (void) faceAwareFill;

@end
