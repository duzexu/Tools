

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@interface SliderControl : UIControl 

/**
 *  滑块的级数。
 */
@property (nonatomic, assign) int numberOfPages;

/**
 *  当前滑块的位置。
 */
@property (nonatomic, assign) int sliderIndex;

/**
 *  滑块的背景视图。
 */
@property (nonatomic, retain) UIImageView *bgImgView;

/**
 *  滑块视图。
 */
@property (nonatomic, retain) UIImageView *sliderImgView;

/**
 *  滑动结束时为YES，其它状态为NO。
 */
@property (assign, nonatomic, getter = touchIsEnd) BOOL touchIsEnd;

/**
 *  滑块的左边背景颜色和右边背景颜色;默认淡蓝色和白色，可自己设置为任意色。
 */
@property (retain, nonatomic) UIView *leftColorView, *rightColorView;


/**
 *  初始化滑块。
 *  @param  frame:滑块视图的坐标位置。
 *  @param  pageNum:滑块的级数
 */
- (id)initWithFrame:(CGRect)frame andPageNum:(int)pageNum;

/**
 *  设置滑块位置。
 *  @param  page:将滑块移动到page所在位置。
 *  @param  animated:是否以动画显示。
 */
- (void)moveSliderToIndex:(int)index animated:(BOOL)animated;

/**
 *  设置滑块的位置刻度标签。
 *  @param  titles:标签数组，count等于numberOfPages，否则报错。
 */
- (void)setSliderLabelTitle:(NSArray *)titles;

@end

