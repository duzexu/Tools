//
//  CycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by Duzexu on 9/14/12.
//  Copyright (c) 2012 Duzexu. All rights reserved.
//

#import "CycleScrollView.h"

@interface CycleScrollView ()<UIScrollViewDelegate>
{
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_visiableViews;
}

@end

@implementation CycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        
        [self addSubview:_pageControl];
        
        _curPage = 0;
        _cycleEnabled = YES;
    }
    return self;
}

- (void)setDataource:(id<CycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (NSInteger)currentPage
{
    return _curPage;
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPagesInCycleScrollView:self];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    if (!_cycleEnabled) {
        _pageControl.currentPage = _curPage;
        //从scrollView上移除所有的subview
        NSArray *subViews= [_scrollView subviews];
        if([subViews count] != 0) {
            [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [self getDisplayImagesWithCurpage:_curPage+1];
        
        for (int i = 0; i < 3; i++) {
            UIView *v = [_visiableViews objectAtIndex:i];
            CGRect frame = v.frame;
            frame.origin.x = 0;
            v.frame = CGRectOffset(frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
        
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    [self loadData];
}

- (void)loadData
{
    if (!_cycleEnabled) {
        if (_curPage <= 0 || _curPage >= _totalPages-1) {
            return;
        }
    }

    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [_visiableViews objectAtIndex:i];
        CGRect frame = v.frame;
        frame.origin.x = 0;
        v.frame = CGRectOffset(frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:page-1];
    NSInteger last = [self validPageValue:page+1];
    
    if (!_visiableViews) {
        _visiableViews = [[NSMutableArray alloc] init];
    }
    
    [_visiableViews removeAllObjects];

    UIView *clean = [[UIView alloc]initWithFrame:self.bounds];
    if (!_cycleEnabled && page <= 0) {
        [_visiableViews addObject:clean];
    }else{
        [_visiableViews addObject:[_datasource cycleScrollView:self viewForRowAtIndex:pre]];
    }
    
    [_visiableViews addObject:[_datasource cycleScrollView:self viewForRowAtIndex:page]];
    
    if (!_cycleEnabled && page >= _totalPages-1) {
        [_visiableViews addObject:clean];
    }else{
        [_visiableViews addObject:[_datasource cycleScrollView:self viewForRowAtIndex:last]];
    }
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_visiableViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_visiableViews objectAtIndex:i];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        if (!_cycleEnabled) {
            if (_curPage >= _totalPages-1) {
                return;
            }
        }
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        if (!_cycleEnabled) {
            if (_curPage <= 0) {
                return;
            }
        }
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
    
    if (!_cycleEnabled) {
        if (_curPage == _totalPages-1) {
            if (x == _scrollView.frame.size.width) {
                _curPage--;
                _pageControl.currentPage = _curPage;
            }
        }
        if (_curPage == 0) {
            if (x == _scrollView.frame.size.width) {
                _curPage++;
                _pageControl.currentPage = _curPage;
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    if (!_cycleEnabled) {
        if(aScrollView.contentOffset.x >= (2*self.frame.size.width)) {
            _curPage = _totalPages-1;
            _pageControl.currentPage = _curPage;
        }
        if(aScrollView.contentOffset.x <= 0) {
            _curPage = 0;
            _pageControl.currentPage = _curPage;
        }
        if (_curPage <= 0 || _curPage >= _totalPages-1) {
            return;
        }
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

@end
