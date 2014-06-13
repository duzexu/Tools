//
//  MBMenuView.h
//  ADFramework
//
//  Created by DuZexu on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
//  模仿iphone的界面，长按删除

#import <UIKit/UIKit.h>

@class MBMenuItem;
@protocol MBMenuViewDelegate;
@interface MBMenuView : UIView<UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained) id<MBMenuViewDelegate> delegate;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) BOOL editing;

- (void)startEditing;
- (void)endEditing;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////
@protocol MBMenuViewDelegate <NSObject>
@optional
- (void)menuView:(MBMenuView *)menuView didSelectedAtItem:(MBMenuItem *)item;
- (void)menuView:(MBMenuView *)menuView didStartEditing:(MBMenuItem *)item;
- (void)menuView:(MBMenuView *)menuView didDeleteItem:(MBMenuItem *)item;
- (void)menuView:(MBMenuView *)menuView didEndEditing:(NSArray *)items;
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MBMenuItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL deleteable;

+ (MBMenuItem *)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url;
+ (MBMenuItem *)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url deleteable:(BOOL)deleteable;

@end