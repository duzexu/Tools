//
//  CycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by Duzexu on 9/14/12.
//  Copyright (c) 2012 Duzexu. All rights reserved.
//

#import "CycleScrollView.h"

@implementation CycleScrollView

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize currentPage = _curPage;
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_scrollView release];
    [_pageControl release];
    [_curViews release];
    [super dealloc];
}

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

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    if (!_cycleEnabled) {
        //从scrollView上移除所有的subview
        NSArray *subViews = [_scrollView subviews];
        if([subViews count] != 0) {
            [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
        
        [self getDisplayImagesWithCurpage:_curPage];
        
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            [singleTap release];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [_scrollView addSubview:v];
        }
        
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
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
        UIView *v = [_curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        [singleTap release];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    UIView *clean = [[UIView alloc]initWithFrame:self.bounds];
    if (!_cycleEnabled && _curPage <= 0) {
        [_curViews addObject:clean];
    }else{
        [_curViews addObject:[_datasource pageAtIndex:pre]];
    }
    
    [_curViews addObject:[_datasource pageAtIndex:page]];
    
    if (!_cycleEnabled && _curPage >= _totalPages-1) {
        [_curViews addObject:clean];
    }else{
        [_curViews addObject:[_datasource pageAtIndex:last]];
    }
    [clean release];
 
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [_curViews objectAtIndex:i];
            v.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleTap:)];
            [v addGestureRecognizer:singleTap];
            [singleTap release];
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
