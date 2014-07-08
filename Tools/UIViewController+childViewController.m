//
//  UIViewController+childViewController.m
//  controller
//
//  Created by DuZexu on 14-7-4.
//  Copyright (c) 2014年 Duzexu. All rights reserved.
//

#import "UIViewController+childViewController.h"

@implementation UIViewController (childViewController)
- (void)addSubViewController:(UIViewController *)controller {
    [self addSubViewController:controller animated:DEFAULT_ANIMATED];
}

- (void)addSubViewController:(UIViewController *)controller animated:(BOOL)flag {
    [self addSubViewController:controller duration:DEFAULT_DURATION options:DEFAULT_ADD_OPTION animated:flag completion:nil];
}

- (void)addSubViewController:(UIViewController *)controller to:(CGPoint)point animated:(BOOL)flag {
    CGPoint from = point;
    switch (DEFAULT_ADD_OPTION) {
        case UIViewAnimationOptionTransitionFlipFromLeft:
            from.x = -CGRectGetWidth(controller.view.frame);
            break;
        case UIViewAnimationOptionTransitionFlipFromRight:
            from.x = CGRectGetWidth(controller.view.frame) + CGRectGetWidth(self.view.frame);
            break;
        case UIViewAnimationOptionTransitionFlipFromTop:
            from.y = -CGRectGetHeight(controller.view.frame);
            break;
        case UIViewAnimationOptionTransitionFlipFromBottom:
            from.y = CGRectGetHeight(controller.view.frame) + CGRectGetHeight(self.view.frame);
            break;
        default:
            break;
    }
    [self addSubViewController:controller from:from to:point duration:DEFAULT_DURATION animated:flag completion:nil];
}

- (void)addSubViewController:(UIViewController *)controller
                    duration:(NSTimeInterval)duration
                     options:(UIViewAnimationOptions)options
                    animated:(BOOL)flag
                  completion:(void (^)(BOOL finished))completion {
    CGPoint from = CGPointZero;
    switch (options) {
        case UIViewAnimationOptionTransitionFlipFromLeft:
            from.x -= CGRectGetWidth(controller.view.frame);
            break;
        case UIViewAnimationOptionTransitionFlipFromRight:
            from.x += CGRectGetWidth(controller.view.frame);
            break;
        case UIViewAnimationOptionTransitionFlipFromTop:
            from.y -= CGRectGetHeight(controller.view.frame);
            break;
        case UIViewAnimationOptionTransitionFlipFromBottom:
            from.y += CGRectGetHeight(controller.view.frame);
            break;
        default:
            break;
    }
    [self addSubViewController:controller from:from to:CGPointZero duration:duration animated:flag completion:completion];
}

- (void)addSubViewController:(UIViewController *)controller
                        from:(CGPoint)from
                          to:(CGPoint)to
                    duration:(NSTimeInterval)duration
                    animated:(BOOL)flag
                  completion:(void (^)(BOOL finished))completion {
    if ([self.childViewControllers containsObject:controller]) {
        return;
    }
    [self addChildViewController:controller];
	[self.view addSubview:controller.view];
	[controller didMoveToParentViewController:self];
    if (flag) {
        CGRect frame = controller.view.frame;
        frame.origin = from;
        controller.view.frame = frame;
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = controller.view.frame;
            frame.origin = to;
            controller.view.frame = frame;
        } completion:^(BOOL finished) {
            if (completion != nil) completion(finished);
        }];
    } else {
        CGRect frame = controller.view.frame;
        frame.origin = to;
        controller.view.frame = frame;
        if (completion != nil) completion(YES);
    }
}

- (IBAction)removeViewController NS_AVAILABLE_IOS(5_0){
    [self removeViewControllerAnimated:DEFAULT_ANIMATED];
}

- (void)removeViewControllerAnimated:(BOOL)flag {
    [self removeViewControllerDuration:DEFAULT_DURATION options:DEFAULT_REMOVE_OPTION animated:flag completion:nil];
}

- (void)removeViewControllerDuration:(NSTimeInterval)duration
                        options:(UIViewAnimationOptions)options
                       animated:(BOOL)flag
                     completion:(void (^)(BOOL finished))completion {
    CGRect parentFrame = self.parentViewController.view.frame;
    CGPoint to = CGPointZero;
    switch (options) {
        case UIViewAnimationOptionTransitionFlipFromLeft:
            to.x = -CGRectGetWidth(parentFrame);
            break;
        case UIViewAnimationOptionTransitionFlipFromRight:
            to.x = CGRectGetWidth(parentFrame) + CGRectGetWidth(self.view.frame);
            break;
        case UIViewAnimationOptionTransitionFlipFromTop:
            to.y = -CGRectGetHeight(parentFrame);
            break;
        case UIViewAnimationOptionTransitionFlipFromBottom:
            to.y = CGRectGetHeight(parentFrame) + CGRectGetHeight(self.view.frame);
            break;
        default:
            break;
    }
    [self removeViewControllerTo:to duration:duration animated:flag completion:completion];
}

- (void)removeViewControllerTo:(CGPoint)to
               duration:(NSTimeInterval)duration
               animated:(BOOL)flag
             completion:(void (^)(BOOL finished))completion {
    if (self.parentViewController == nil) {
        return;
    }
    [self willMoveToParentViewController:nil];
    if (flag) {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.view.frame;
            frame.origin = to;
            self.view.frame = frame;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            if (completion != nil) completion(finished);
        }];
    } else {
        CGRect frame = self.view.frame;
        frame.origin = to;
        self.view.frame = frame;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if (completion != nil) completion(YES);
    }
}

- (void)addChildViewControllerSimpleWithView:(UIView *)view
								  controller:(UIViewController *)controller
{
	[self addChildViewController:controller];
	[view addSubview:[controller view]];
	[controller didMoveToParentViewController:self];
}

- (void)removeFromParentViewControllerSimpleWithView:(UIView *)view
{
	[self willMoveToParentViewController:nil];
	[view removeFromSuperview];
	[self removeFromParentViewController];
}

@end
