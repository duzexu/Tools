//
//  UIImage+Auto_fit.m
//  Tools
//
//  Created by WangMengZhi on 13-5-6.
//  Copyright (c) 2013年 Duzexu. All rights reserved.
//

#import "UIImage+Auto_fit.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@implementation UIImage (Auto_fit)

+ (UIImage *)imageNamedWithiPhone5:(NSString *)name imageTyped:(NSString *)type

{
    
    NSString *imgName = nil;
    
    if ([type length]==0) {
        
        type = @"png";
        
    }else
        
    {
        
        type = type;
        
    }
    
    if (iPhone5) {
        
        imgName = [NSString stringWithFormat:@"%@-ip5",name];
        
    }else{
        
        imgName = name;
        
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:type];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
    
}

@end
