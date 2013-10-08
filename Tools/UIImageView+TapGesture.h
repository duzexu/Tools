//
//  UIImageView+TapGesture.h
//  UIImageViewTapBlockDemo
//
//  Created by sdm on 13-5-18.
//  Copyright (c) 2013年 sdm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tapGestureBlock)(UIImageView *imageView);

@interface UIImageView (TapGesture)

- (void)addTapGesture:(tapGestureBlock)tapBlock;

@end
