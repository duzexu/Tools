#import <UIKit/UIKit.h>
//  使用图层蒙版为视图添加圆角
@interface UIView (RoundedCorners)

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGSize)size;

@end