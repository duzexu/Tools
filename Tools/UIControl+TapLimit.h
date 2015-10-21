//
//  UIControl+TapLimit.h
//  Tools
//
//  Created by yemalive on 15/9/16.
//  Copyright (c) 2015年 Duzexu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (TapLimit)

@property (nonatomic,assign) NSTimeInterval uxy_acceptEventInterval;// 可以用这个给重复点击加间隔

@end
