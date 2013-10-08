//
//  UIImageView+TapGesture.m
//  UIImageViewTapBlockDemo
//
//  Created by sdm on 13-5-18.
//  Copyright (c) 2013年 sdm. All rights reserved.
//

#import "UIImageView+TapGesture.h"

static tapGestureBlock _tapBlock;
@implementation UIImageView (TapGesture)

- (void)addTapGesture:(tapGestureBlock)tapBlock
{
    _tapBlock = [tapBlock copy];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:recognizer];
    [recognizer release];
}

- (void)imageViewTap
{
    _tapBlock(self);
}

@end
