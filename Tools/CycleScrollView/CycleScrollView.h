//
//  CycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by Duzexu on 9/14/12.
//  Copyright (c) 2012 Duzexu. All rights reserved.
//
//  循环复用的ScrollView，可设置循环滚动

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDelegate;
@protocol CycleScrollViewDatasource;

@interface CycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    id<CycleScrollViewDelegate> _delegate;
    id<CycleScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (assign, nonatomic,getter = isCycleEnabled) BOOL cycleEnabled; // Default is Yes 
@property (nonatomic,assign,setter = setDataource:) id<CycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<CycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(CycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol CycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
