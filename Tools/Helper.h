//
//  Header.h
//  Tools
//
//  Created by DuZexu on 13-5-20.
//  Copyright (c) 2013年 Duzexu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
// -------------------------------------------------------------------------------
//	viewDidUnload
//  iOS 6 no longer unloads views under low memory conditions so this method
//  will not be called.  On iOS 5, unload anything that will be recreated in
//  viewDidLoad.
// -------------------------------------------------------------------------------
- (void)viewDidUnload
{
    [super viewDidUnload];
}
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
// -------------------------------------------------------------------------------
//	shouldAutorotateToInterfaceOrientation:
//  Disable rotation on iOS 5.x and earlier.  Note, for iOS 6.0 and later all you
//  need is "UISupportedInterfaceOrientations" defined in your Info.plist
// -------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif

/**
 *  @brief  Debug模式下打印
 */
#ifdef DEBUG
#define ADLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define ADLog(...) do { } while (0)
#endif

/**
 *  @brief  release方法
 *
 *  @param  obj id类型  要release的对象
 *
 *  @return  id类型
 */
static inline id _release(id obj) {
#if !( __has_feature(objc_arc))
    if (obj) [obj release], obj = nil;
#endif
    return obj;
}
/**
 *  @brief  在某点旋转一定角度
 *
 *  @param  angle  CGFloat型  旋转的角度
 *  @param  pt     CGPoint型  围绕的点
 *
 *  @return CGAffineTransform型
 */
static CGAffineTransform CGAffineTransformMakeRotationAt(CGFloat angle, CGPoint pt){
    const CGFloat fx = pt.x;
    const CGFloat fy = pt.y;
    const CGFloat fcos = cos(angle);
    const CGFloat fsin = sin(angle);
    return CGAffineTransformMake(fcos, fsin, -fsin, fcos, fx - fx * fcos + fy * fsin, fy - fx * fsin - fy * fcos);
}

/**
 *  @brief  点击UIViewController的任何地方使键盘消失
 *
 *  或者在VC中重写touchbegin方法[self.vew endEditing:YES];
 */
#define DisMissKeybord  [[[UIApplication sharedApplication] keyWindow] endEditing:YES]

/**
 *  @brief  移除view上的所有subviews
 */
#define RemoveAllSubviews(view) [[view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)]

/**
 *  @brief  得到UUID
 */
#define GetUUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

/**
 *  @brief  输出
 */
#define NSLog(format, ...)   fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

/**
 *  NSString实用方法
 */
#define NSStringFromInt(intValue) [NSString stringWithFormat:@"%d",intValue]
#define NSStringFromFloat(floatValue) [NSString stringWithFormat:@"%f",floatValue]

#define Keypath(keypath) (strchr(#keypath, '.') + 1)
