//
//  CheckBox.h
//  duzexu
//
//  Created by duzexu on 13-7-9.
//  Copyright (c) 2013年 duzexu. All rights reserved.
//
//  多选按钮

#import <UIKit/UIKit.h>

@protocol CheckBoxDelegate;

@interface CheckBox : UIButton {
    id<CheckBoxDelegate> _delegate;
    BOOL _checked;
}

@property(nonatomic, assign)  IBOutlet id<CheckBoxDelegate>  delegate;
@property(nonatomic, assign)  BOOL                           checked;

- (id)initWithDelegate:(id)delegate;

@end

@protocol CheckBoxDelegate <NSObject>

@optional

- (void)didSelectedCheckBox:(CheckBox *)checkbox checked:(BOOL)checked;

@end
