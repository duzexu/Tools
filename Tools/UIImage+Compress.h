//
//  UIImage+Compress.h
//  test
//
//  Created by duzexu on 16/3/21.
//  Copyright © 2016年 duzexu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Compress)

- (NSData *)compressToTargetSize:(NSUInteger)targetSize;

@end
