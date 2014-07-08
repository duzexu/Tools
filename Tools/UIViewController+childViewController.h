//
//  UIViewController+childViewController.h
//  controller
//
//  Created by DuZexu on 14-7-4.
//  Copyright (c) 2014年 Duzexu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_DURATION 0.5
#define DEFAULT_ADD_OPTION UIViewAnimationOptionTransitionFlipFromBottom
#define DEFAULT_REMOVE_OPTION UIViewAnimationOptionTransitionFlipFromTop
#define DEFAULT_ANIMATED YES

@interface UIViewController (childViewController)
/**
 *  子控制器添加
 *
 */
- (void)addSubViewController:(UIViewController *)controller NS_AVAILABLE_IOS(5_0);

- (void)addSubViewController:(UIViewController *)controller animated:(BOOL)flag NS_AVAILABLE_IOS(5_0);

- (void)addSubViewController:(UIViewController *)controller to:(CGPoint)point animated:(BOOL)flag NS_AVAILABLE_IOS(5_0);

- (void)addSubViewController:(UIViewController *)controller
                    duration:(NSTimeInterval)duration
                     options:(UIViewAnimationOptions)options
                    animated:(BOOL)flag
                  completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(5_0);

- (void)addSubViewController:(UIViewController *)controller
                        from:(CGPoint)from
                          to:(CGPoint)to
                    duration:(NSTimeInterval)duration
                    animated:(BOOL)flag
                  completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(5_0);
/**
 *  子控制器删除
 *
 */
- (IBAction)removeViewController NS_AVAILABLE_IOS(5_0);

- (void)removeViewControllerAnimated:(BOOL)flag NS_AVAILABLE_IOS(5_0);

- (void)removeViewControllerDuration:(NSTimeInterval)duration
                             options:(UIViewAnimationOptions)options
                            animated:(BOOL)flag
                          completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(5_0);

- (void)removeViewControllerTo:(CGPoint)to
                      duration:(NSTimeInterval)duration
                      animated:(BOOL)flag
                    completion:(void (^)(BOOL finished))completion NS_AVAILABLE_IOS(5_0);

@end
