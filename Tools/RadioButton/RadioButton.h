//
//  RadioButton.h
//  duzexu
//
//  Created by duzexu on 13-7-9.
//  Copyright (c) 2013年 duzexu All rights reserved.
//
//  互斥按钮

#import <UIKit/UIKit.h>

@protocol RadioButtonDelegate;

@interface RadioButton : UIButton {
    NSString                        *_groupId;
    BOOL                            _checked;
    id<RadioButtonDelegate>       _delegate;
}

@property(nonatomic, assign) IBOutlet id<RadioButtonDelegate>   delegate;
@property(nonatomic, copy, readonly)  NSString                   *groupId;
@property(nonatomic, assign)          BOOL                       checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

@end

@protocol RadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(RadioButton *)radio groupId:(NSString *)groupId;

@end
