//
//  BaseScrollView.m
//  SkodaMobileCare
//
//  Created by DuZexu on 13-7-23.
//  Copyright (c) 2013年 Duzexu. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self initSelf];
    }
    return self;
}

- (void)initSelf{
    @try {
        [self flashScrollIndicators];
        for (UIImageView *indicator in self.subviews) {
            CGSize size = indicator.frame.size;
            if (size.width > size.height) {
                _horizontalIndicator = indicator;   //水平
            } else {
                _verticalIndicator = indicator;     //垂直
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%s %d %@",__FUNCTION__,__LINE__,exception);
    }
}

- (NSArray *)contentSubviews{
    __autoreleasing NSMutableArray *subviews = [NSMutableArray arrayWithArray:[self subviews]];
    [subviews removeObject:_horizontalIndicator];
    [subviews removeObject:_verticalIndicator];
    return subviews;
}


- (void)scrollToTopAnimated:(BOOL)animation{
    [self setContentOffset:CGPointMake(0, 0) animated:animation];
}

- (void)scrollToBottomAnimated:(BOOL)animation{
    float offsetY = self.contentSize.height - self.frame.size.height - 10;
    offsetY = offsetY > 0 ? offsetY : 0;
    [self setContentOffset:CGPointMake(0, offsetY) animated:animation];
}


- (void)contentSizeToFit{
    
    CGRect contentRect = CGRectZero;
    for (UIView *subview in self.subviews) {
        if (![subview isEqual:_verticalIndicator]) {
            contentRect = CGRectUnion(contentRect, subview.frame);
        }
    }
    float contentHeight = contentRect.size.height;
    
    if (contentHeight > self.bounds.size.height) {
        contentHeight += 10;    //margin bottom.
    }
    self.contentSize = CGSizeMake(self.frame.size.width, contentHeight);
}


- (void)willRemoveSubview:(UIView *)subview{
    if (![subview isKindOfClass:NSClassFromString(@"UIAutocorrectInlinePrompt")] &&
        ![subview isKindOfClass:NSClassFromString(@"UISelectionGrabberDot")]) {
        [self contentSizeToFit];
    }
}

- (void)didAddSubview:(UIView *)subview{
    if (![subview isKindOfClass:NSClassFromString(@"UIAutocorrectInlinePrompt")] &&
        ![subview isKindOfClass:NSClassFromString(@"UISelectionGrabberDot")]) {
        [self contentSizeToFit];
    }
}


@end
