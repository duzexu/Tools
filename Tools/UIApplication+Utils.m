//
//  UIApplication+Utils.m
//  test
//
//  Created by duzexu on 16/10/14.
//  Copyright © 2016年 duzexu. All rights reserved.
//

#import "UIApplication+Utils.h"

@implementation UIApplication (Utils)

- (UIViewController *)ad_topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    while (resultVC.childViewControllers.count > 0) {
        resultVC = resultVC.childViewControllers[0];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end
