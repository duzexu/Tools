//
//  MaskView.m
//  MaskView
//
//  Created by WangMengZhi on 13-3-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MaskView.h"

@implementation MaskView
@synthesize linesArray = _linesArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(Pan:)];
        [self addGestureRecognizer:pan];
        [pan release];
        self.opaque = NO;
    }
    return self;
}

- (NSMutableArray*)linesArray
{
    if (linesArray == nil) {
        linesArray = [[NSMutableArray alloc]init];
    }
    return linesArray;
}

- (void)dealloc
{
    [super dealloc];
    [linesArray release];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext(); 
    CGImageRef sourceImage = [[UIImage imageNamed:@"mask.png"] CGImage];
    CGContextDrawImage(context, CGRectMake(0, 0, 320, 460), sourceImage);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 2*20);
    for (NSDictionary *dic in linesArray) {
        CGMutablePathRef paintPath = CGPathCreateMutable();
        NSArray *linePointArray = [dic objectForKey:@"line"];
        for (NSInteger i=0; i<linePointArray.count; i++) {
            CGPoint point = [[linePointArray objectAtIndex:i]CGPointValue];
            if (i==0) {
                CGPathMoveToPoint(paintPath, NULL, point.x, point.y);
            }else {
                CGPathAddLineToPoint(paintPath, NULL, point.x, point.y);
            }
        }
        CGContextAddPath(context, paintPath);
        CGContextStrokePath(context);
    }
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    CGImageRef imageWithAlpha = sourceImage;
    //add alpha channel for images that don’t have one (ie GIF, JPEG, etc…)
    //this however has a computational cost
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        imageWithAlpha = [self CopyImageAndAddAlphaChannel :sourceImage];
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, cgImage);
    CGImageRelease(cgImage);
    //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    //CGImageRef result = [self maskImage:[UIImage imageNamed:@"mask.png"] withMask:cgImage];
    CGContextDrawImage(context, CGRectMake(0, 0, 320, 460), masked);
	CGImageRelease(masked);
}

//给图片添加alpha通道
-(CGImageRef) CopyImageAndAddAlphaChannel :(CGImageRef) sourceImage
{
    CGImageRef retVal = NULL;
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    
    if (offscreenContext != NULL) {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    return retVal;
}

- (void)Pan:(UIPanGestureRecognizer*)sender
{
    CGPoint touchPoint = [sender locationInView:self];
    if (sender.state==UIGestureRecognizerStateBegan) {
        NSMutableArray *currentLineArray = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:touchPoint]];
        NSMutableDictionary *lineDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:currentLineArray,@"line", nil];
        [self.linesArray addObject:lineDic];
    }else if(sender.state==UIGestureRecognizerStateChanged){
        NSMutableDictionary *lineDic = [self.linesArray lastObject];
        NSMutableArray *currentLineArray = [lineDic objectForKey:@"line"];
        [currentLineArray addObject:[NSValue valueWithCGPoint:touchPoint]];
        [self setNeedsDisplay];
    }
}

@end
