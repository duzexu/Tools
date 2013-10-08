//
//  ViewController.m
//  MaskView
//
//  Created by WangMengZhi on 13-3-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "ImageMaskView.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize MyMaskView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    //
//    self.MyMaskView = [[MaskView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
//    self.MyMaskView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.MyMaskView];
    //
    //
//    ImageMaskView *image = [[ImageMaskView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)image:[UIImage imageNamed:@"D02.jpg"]];
//    [self.view addSubview:image];
//    [image release];
    //
    //
//    STScratchView *scratchView = [[STScratchView alloc]init];
//    scratchView.frame = self.view.frame;
//    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mask.png"]];
//    image.frame = self.view.frame;
//    [scratchView setSizeBrush:20];
//    [scratchView setHideView:image];
//    [self.view addSubview:scratchView];
//    [scratchView release];
//    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"Path:"]]) {
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"Path:"]];
//    }else {
//        NSLog(@"打不开");
//    }
}

- (void)viewDidUnload
{
    [self setMyMaskView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [MyMaskView release];
    [super dealloc];
}
@end
