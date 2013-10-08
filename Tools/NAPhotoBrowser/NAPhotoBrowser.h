

#import <UIKit/UIKit.h>
#import "NAPhoto.h"
#import "DataBase.h"

@class ZoomingScrollView;

@interface NAPhotoBrowser : UIViewController <UIScrollViewDelegate,NAPhotoDelegate>{
	
	// Photos
	NSArray *photos;
	
	// Views
	UIScrollView *pagingScrollView;
	
	// Paging
	NSMutableSet *visiblePages, *recycledPages;
	int currentPageIndex;
	int pageIndexBeforeRotation;
	
	// Navigation & controls
//	UIToolbar *toolbar;
//	NSTimer *controlVisibilityTimer;
//	UIBarButtonItem *previousButton, *nextButton;
    
	BOOL performingLayout;
	BOOL rotating;
	
//    UINavigationController * nc;
}

// Init
- (id)initWithPhotos:(NSArray *)photosArray;

// Photos
- (UIImage *)imageAtIndex:(int)index;

// Layout
- (void)performLayout;

// Paging
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(int)index;
- (ZoomingScrollView *)pageDisplayedAtIndex:(int)index;
- (ZoomingScrollView *)dequeueRecycledPage;
- (void)configurePage:(ZoomingScrollView *)page forIndex:(int)index;
- (void)didStartViewingPageAtIndex:(int)index;

// Frames
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (CGPoint)contentOffsetForPageAtIndex:(int)index;
- (CGRect)frameForNavigationBarAtOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation;

// Navigation
- (void)updateNavigation;
- (void)jumpToPageAtIndex:(int)index;
- (void)gotoPreviousPage;
- (void)gotoNextPage;

// Controls
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
- (void)setControlsHidden:(BOOL)hidden;
- (void)toggleControls;

// Properties
- (void)setInitialPageIndex:(int)index;

@end
