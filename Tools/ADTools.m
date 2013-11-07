//
//  ADTools.m
//  Tools
//
//  Created by WangMengZhi on 13-5-3.
//  Copyright (c) 2013年 Duzexu. All rights reserved.
//

#import "ADTools.h"
#import <QuartzCore/QuartzCore.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netdb.h>
@implementation ADTools
/**
 *  @brief  判断邮箱格式是否正确 利用正则表达式验证
 *
 *  @param  email NSString类型 要判断的邮箱名
 *
 *  @return BOOL型 是否正确
 */
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
/**
 *  @brief  图片形状改变
 *
 *  @param  image   UIImage型  原始图片
 *  @param  newSize CGSize型   要改变的大小
 *
 *  @return UIImage型  改变后的图片
 */
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this newcontext, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
/**
 *  @brief  截取屏幕图片(引入QuartzCore)
 *
 *  @param  size  CGSize型  截取的大小
 *  @param  view  UIView型  截取的原始view
 *
 *  @return UIImage型  截取的图片
 */
- (UIImage*)getScreenImageInRect:(CGSize)size onView:(UIView*)view
{
    //创建一个基于位图的图形上下文并指定大小为size
    UIGraphicsBeginImageContext(size);
    //renderInContext 呈现接受者及其子范围到指定的上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //返回一个基于当前图形上下文的图片
    UIImage *aImage = UIGraphicsGetImageFromCurrentImageContext();
    //移除栈顶的基于当前位图的图形上下文
    UIGraphicsEndImageContext();
    return aImage;
    //苹果最新接口
//    CGImageRef UIGetScreenImage();
//    CGImageRef img = UIGetScreenImage();
//    UIImage* scImage=[UIImage imageWithCGImage:img];
//    return scImage;
}
/**
 *  @brief  图片上添加文字
 *
 *  @param  img    UIImage型   需要加文字的图片
 *  @param  atext  NSString型  文字描述
 *
 *  @return  UIImage型  加好文字的图片
 */
-(UIImage *)addText:(UIImage *)img text:(NSString *)atext
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[atext cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Georgia", 15, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0, 255, 255, 0.8);
    
    //位置调整
    CGContextShowTextAtPoint(context, w/2-strlen(text)*4.5 , h - 135, text, strlen(text));
    
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}
/**
 *  @brief  查看网络连接是否可用(引入SystemConfiguration netdb)
 *
 *  @return BOOL型 是否可用
 */
-(BOOL)netWorkIsExistence{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
/**
 *  @brief  给文件路径添加不要备份属性
 *          应用的离线文件(如杂志,地图等)添加不要备份属性可以避免被itunes和iCloud备份
 *          系统是5.0.1以上的才支持
 *          引入 #import <sys/xattr.h>
 *  @return BOOL型 是否成功
 */
#import <sys/xattr.h>
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)aFilePath
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:aFilePath]);
    
    NSError *error = nil;
    BOOL success = NO;
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 5.1f)
    {
        success = [[NSURL fileURLWithPath:aFilePath] setResourceValue:[NSNumber numberWithBool:YES]
                                                               forKey:NSURLIsExcludedFromBackupKey
                                                                error:&error];
    }
    else if ([systemVersion isEqualToString:@"5.0.1"])
    {
        const char* filePath = [aFilePath fileSystemRepresentation];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        success = (result == 0);
    }
    else
    {
        NSLog(@"Can not add 'do no back up' attribute at systems before 5.0.1");
    }
    
    if(!success)
    {
        NSLog(@"Error excluding %@ from backup %@", [aFilePath lastPathComponent], error);
    }
    
    return success;
}
/**
 *  @brief  读取一张图片的属性,而不用把图片读取到内存(加入 ImageI/O 框架)
 *
 *  @param  imageName    NSString型   图片名
 *
 */
#import <ImageIO/ImageIO.h>
- (void)imageProperties:(NSString*)imageName
{
    //#import <ImageIO/ImageIO.h>
    //Some path
    NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName];
    NSURL* imageFileURL = [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageFileURL, NULL);
    if (imageSource) {
        NSDictionary* options = @{(NSString*)kCGImageSourceShouldCache:@NO};
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)options);
        if (imageProperties) {
            NSLog( @"properties: %@", imageProperties);
            CFRelease(imageProperties);
        }
    } else {
        NSLog(@" Error loading image");
    }
}
@end
