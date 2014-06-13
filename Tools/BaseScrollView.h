//
//  BaseScrollView.h
//  SkodaMobileCare
//
//  Created by DuZexu on 13-7-23.
//  Copyright (c) 2013年 Duzexu. All rights reserved.
//
//  自动适应子视图高度的ScrollowView

#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView

@property (unsafe_unretained, nonatomic, readonly) UIImageView *verticalIndicator;
@property (unsafe_unretained, nonatomic, readonly) UIImageView *horizontalIndicator;

- (void)scrollToTopAnimated:(BOOL)animation;
- (void)scrollToBottomAnimated:(BOOL)animation;

- (NSArray *)contentSubviews;

//子视图位置变化时调整contentSize。
- (void)contentSizeToFit;

@end
