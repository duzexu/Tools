//
//  MBMenuView.m
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//

#import "MBMenuView.h"

#define kMenuButtonWidth 60
#define kMenuButtonHeight 80.0

#define kMenuImageMargin 1
#define kMenuImageWidth 58.0

#define kMenuTextLabelHeight 40

#define kNormalTextColor [UIColor colorWithRed:(32 / 255.0) green:(32 / 255.0) blue:(32 / 255.0) alpha:1]

///////////////////////////////////////////////////////////////////////////////////////////////////
@class MBMenuButton;
@protocol MBMenuButtonDelegate <NSObject>
@optional
- (void)menuButtonDidDeleteButton:(MBMenuButton *)button;

@end

@interface MBMenuButton : UIView {
    UIButton *deleteButton;
}
@property (nonatomic, unsafe_unretained) id<MBMenuButtonDelegate> delegate;
@property (nonatomic, strong) MBMenuItem *item;
@property (nonatomic, unsafe_unretained) UIPanGestureRecognizer *panGesture;

- (void)showDeleteButton:(BOOL)show;
@end

@implementation MBMenuButton

+ (MBMenuButton *)buttonWithItem:(MBMenuItem *)item{
    return [[MBMenuButton alloc] initWithItem:item];
}

- (void)dealloc{
    self.delegate = nil;
    [super dealloc];
}

- (MBMenuButton *)initWithItem:(MBMenuItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMenuImageMargin, 0, kMenuImageWidth, kMenuImageWidth)];
        imageView.image = item.image;
        [self addSubview:imageView];
        
        if (item.deleteable) {
            deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteButton.alpha = 0;
            [deleteButton addTarget:self action:@selector(deleteItem) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            deleteButton.frame = CGRectMake(-10, -12, 30, 30);
            [self addSubview:deleteButton];
        }
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kMenuImageWidth + 5, kMenuButtonWidth, kMenuTextLabelHeight)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:12];
        textLabel.textColor = kNormalTextColor;
        textLabel.text = item.title;
        [self addSubview:textLabel];
        [textLabel sizeToFit];
        CGSize size = textLabel.frame.size;
        textLabel.frame = CGRectMake((kMenuButtonWidth - size.width) / 2, kMenuImageWidth + 5, size.width, size.height);
    }
    return self;
}

- (void)showDeleteButton:(BOOL)show{
    if (show) {
        deleteButton.alpha = 1;
    } else {
        deleteButton.alpha = 0;
    }
}


#pragma mark- MBMenuButtonDelegate Methods
- (void)deleteItem{
    if (_delegate && [_delegate respondsToSelector:@selector(menuButtonDidDeleteButton:)]) {
        [_delegate menuButtonDidDeleteButton:self];
    }
}


@end


///////////////////////////////////////////////////////////////////////////////////////////////////
@interface MBMenuView ()<MBMenuButtonDelegate>{
    BOOL                _pageScrolling;
    NSTimer *           _touchTimer;
    MBMenuButton *      _pressedButton;
    MBMenuButton *      _deleteButton;
    UIScrollView *      _scrollView;
    CGPoint             _startPoint;
    NSMutableArray *    _itemButtons;
    UIPageControl *     _pageControl;
    NSInteger           _numberOfPages;
    NSInteger           _currentPageIndex;
}
@end

@implementation MBMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _editable = NO;
        _editing = NO;
        _pageScrolling = NO;
        _itemButtons = [[NSMutableArray alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 30)];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.hidesForSinglePage = YES;
        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
    }
    return self;
}

- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_itemButtons removeAllObjects];
    
    if (_touchTimer) {
        [_touchTimer invalidate];
        _touchTimer = nil;
    }
    _delegate = nil;
    _pressedButton = nil;
    [super dealloc];
}


- (NSArray *)editedItems{
    NSMutableArray *editedItems = [[NSMutableArray alloc] init];
    for (MBMenuButton *button in _itemButtons){
        [editedItems addObject:button.item];
    }
    return editedItems;
}

- (void)layoutSubviews{
    
    if ([_itemButtons count] > 0) {
        return;
    }
    
    for (UIView *item in _scrollView.subviews){
        [item removeFromSuperview];
    }
    [_itemButtons removeAllObjects];
    
    NSInteger pageItemCount = 12;
    if (iPhone5()) {
        pageItemCount = 16;
    }

    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *stop) {
        MBMenuButton *button = [MBMenuButton buttonWithItem:obj];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureEvent:)];
        [button addGestureRecognizer:tapGesture];
        
        if (_editable) {
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureEvent:)];
            [button addGestureRecognizer:longPressGesture];
            
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureEvent:)];
            panGesture.enabled = NO;
            button.panGesture = panGesture;
            [button addGestureRecognizer:panGesture];
        }
        
        
        button.delegate = self;
        button.frame = CGRectMake((i / pageItemCount) * 320 +  (i % 4) * 74 + 20,
                                  30 + 102  * (i % pageItemCount / 4),
                                  kMenuButtonWidth,
                                  kMenuButtonHeight);
        button.tag = i;
        [_itemButtons addObject:button];
        [_scrollView addSubview:button];
    }];
    
    NSInteger itemCount = [_items count];
    _numberOfPages = 1 + (itemCount - 1) / pageItemCount;
    _pageControl.numberOfPages = _numberOfPages;
    _scrollView.contentSize = CGSizeMake(_numberOfPages * kScreenWidth , _scrollView.frame.size.height);
}

- (void)tapGestureEvent:(UITapGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        MBMenuButton *button = (MBMenuButton *)[gesture view];
        if (!_editing && _delegate &&
            [_delegate respondsToSelector:@selector(menuView:didSelectedAtItem:)]) {
            [_delegate menuView:self didSelectedAtItem:button.item];
        }
    }
}

- (void)longPressGestureEvent:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (!_editing) {
            _editing = YES;
            _pressedButton = (MBMenuButton *)[gesture view];
            [self buttonStartDrag];
            [self startEditing];
            _startPoint = _pressedButton.center;
            
            if (_delegate && [_delegate respondsToSelector:@selector(menuView:didStartEditing:)]) {
                [_delegate menuView:self didStartEditing:_pressedButton.item];
            }
         } else {
            _pressedButton = (MBMenuButton *)[gesture view];
             _startPoint = _pressedButton.center;
            [self buttonStartDrag];
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (_editing) {
            CGPoint movePoint = [gesture locationInView:_scrollView];
            [self updatePosition:movePoint];
        }
    } else {
        _pressedButton.center = _startPoint;
        [self buttonEndDrag];
    }
    
}

- (void)panGestureEvent:(UIPanGestureRecognizer *)gesture{
    if (_editing) {
        if (gesture.state == UIGestureRecognizerStateBegan) {
            _pressedButton = (MBMenuButton *)[gesture view];
            _startPoint = _pressedButton.center;
            [self buttonStartDrag];
            
        } else if (gesture.state == UIGestureRecognizerStateChanged) {
            CGPoint panPoint = [gesture locationInView:_scrollView];
            [self updatePosition:panPoint];
        } else {
            _pressedButton.center = _startPoint;
            [self buttonEndDrag];
        }
    }
}

- (void)relayoutItems{
    NSInteger pageItemCount = 12;
    if (iPhone5()) {
        pageItemCount = 16;
    }

    [UIView animateWithDuration:0.3 animations:^{
        [_itemButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger i, BOOL *stop) {
            MBMenuButton *button = (MBMenuButton *)obj;
            button.tag = i;
            CGRect rect = CGRectMake((i / pageItemCount) * 320 +  (i % 4) * 75 + 17,
                                     30 + 102  * (i % pageItemCount / 4),
                                     kMenuButtonWidth,
                                     kMenuButtonHeight);
            if (_pressedButton != button) {
                button.frame = rect;
            } else {
                _startPoint =  CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height /2.0);
            }
        }];
    } completion:^(BOOL finished) {
        NSInteger itemCount = [_itemButtons count];
        _numberOfPages = 1 + (itemCount - 1) / pageItemCount;
        _pageControl.numberOfPages = _numberOfPages;
        _scrollView.contentSize = CGSizeMake(_numberOfPages * kScreenWidth , _scrollView.frame.size.height);
    }];
}

- (void)updatePosition:(CGPoint)point{
    _pressedButton.center = point;
    
    float targetAreaWidth = 15;
    float offsetX = kScreenWidth * _currentPageIndex;
    float scrollLeftX = offsetX + targetAreaWidth;
    float scrollRightX = offsetX + kScreenWidth - targetAreaWidth;
    
    NSInteger index = _pressedButton.tag;
    
    for (MBMenuButton *button in _itemButtons){
        if (CGRectContainsPoint(button.frame, point)) {
            if (button.tag != _pressedButton.tag) {
                index = button.tag;
            }
        } 
        if (_numberOfPages > 1) {
            if (point.x > scrollRightX &&
                _currentPageIndex < _numberOfPages - 1 &&
                !_pageScrolling) {
                _pageScrolling = YES;
                [_scrollView setContentOffset:CGPointMake(offsetX + kScreenWidth, 0) animated:YES];
            } else if (point.x < scrollLeftX &&
                       _currentPageIndex > 0 &&
                       !_pageScrolling) {
                _pageScrolling = YES;
                [_scrollView setContentOffset:CGPointMake(offsetX - kScreenWidth, 0) animated:YES];
            }
        }
    }
    
    BOOL shouldRelayoutItems = NO;
    if (_pressedButton.tag < index) {
        for (int i = _pressedButton.tag + 1; i <= index; i++) {
            shouldRelayoutItems = YES;
            [_itemButtons exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
        }
    }
    else if (_pressedButton.tag >= index) {
        for (int i = _pressedButton.tag - 1; i >= index; i--) {
            shouldRelayoutItems = YES;
            [_itemButtons exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
        }
    }
    if (shouldRelayoutItems) {
        [self relayoutItems];
    }
}

- (void)startEditing{
    static BOOL left = NO;
    
    [UIView beginAnimations:nil context:nil];
    [_scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isMemberOfClass:[MBMenuButton class]]) {
            MBMenuButton *button = (MBMenuButton *)obj;
            [button showDeleteButton:YES];
            button.panGesture.enabled = YES;
            if (![button isEqual:_pressedButton]) {
                button.transform = left ? CGAffineTransformMakeRotation(0.03) : CGAffineTransformMakeRotation(-0.03);
            }
        }
    }];
    [UIView commitAnimations];
    
    left = !left;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(startEditing) withObject:nil afterDelay:0.1];

}

- (void)endEditing{
    if (_editing) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [_scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isMemberOfClass:[MBMenuButton class]]) {
                MBMenuButton *button = (MBMenuButton *)obj;
                [button showDeleteButton:NO];
                button.panGesture.enabled = NO;
                button.transform =  CGAffineTransformMakeRotation(0.0);
            }
        }];
        _editing = NO;
        [self relayoutItems];   //避免偏差
        
        if (_delegate && [_delegate respondsToSelector:@selector(menuView:didEndEditing:)]) {
            [_delegate menuView:self didEndEditing:[self editedItems]];
        }
    }
}

- (void)buttonStartDrag{
    [_scrollView bringSubviewToFront:_pressedButton];
    
    [UIView animateWithDuration:0.3 animations:^{
        _pressedButton.transform = CGAffineTransformMakeRotation(0.0);
        _pressedButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _pressedButton.alpha = 0.8;
    } completion:^(BOOL finished) {
    }];
}

- (void)buttonEndDrag{    
    [UIView animateWithDuration:0.3 animations:^{
        _pressedButton.transform = CGAffineTransformMakeScale(1, 1);
        _pressedButton.alpha = 1;
    } completion:^(BOOL finished) {
        _pressedButton = nil;
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(menuView:didDeleteItem:)]) {
            [_delegate menuView:self didDeleteItem:_deleteButton.item];
        }
        [_deleteButton removeFromSuperview];
        [_itemButtons removeObject:_deleteButton];
        [self relayoutItems];
    }
    _deleteButton = nil;
}


#pragma mark - MBMenuButtonDelegate Methods 
- (void)menuButtonDidDeleteButton:(MBMenuButton *)button{
    _deleteButton = button;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"系统提示"
                                                    message:[NSString stringWithFormat:@"是否删除“%@”应用？",button.item.title]
                                                   delegate:self
                                          cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    _currentPageIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _pageScrolling = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = _currentPageIndex;
}

- (void)changePage:(UIPageControl *)pageControl{
    [_scrollView setContentOffset:CGPointMake(pageControl.currentPage * kScreenWidth, 0) animated:YES];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MBMenuItem

+ (MBMenuItem *)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url deleteable:(BOOL)deleteable{
    return [[MBMenuItem alloc] initWithTitle:title image:image url:url deleteable:deleteable];
}


+ (MBMenuItem *)itemWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    return [[MBMenuItem alloc] initWithTitle:title image:image url:url deleteable:NO];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image url:(NSString *)url deleteable:(BOOL)deleteable{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.url = url;
        self.deleteable = deleteable;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"<%@ %p title:%@ url:%@>",[self class],self,_title,_url];
}


@end


