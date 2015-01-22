//
//  CycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by Duzexu on 9/14/12.
//  Copyright (c) 2012 Duzexu. All rights reserved.
//
//  循环复用的ScrollView，可设置循环滚动

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDatasource;

@interface CycleScrollView : UIView

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (assign, nonatomic,getter = isCycleEnabled) BOOL cycleEnabled; // Default is Yes 
@property (nonatomic,weak,setter = setDataource:) id<CycleScrollViewDatasource> datasource;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end

@protocol CycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPagesInCycleScrollView:(CycleScrollView *)cycleScrollView;
- (UIView *)cycleScrollView:(CycleScrollView *)cycleScrollView viewForRowAtIndex:(NSInteger)index;

@end
