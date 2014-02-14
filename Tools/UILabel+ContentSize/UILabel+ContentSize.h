
//计算Label的大小
#import <UIKit/UIKit.h>
 
@interface UILabel (ContentSize)
 
- (CGSize)contentSize;

@end

@interface UILabel (dynamicSizeMe)

-(float)resizeToFit;
-(float)expectedHeight;

@end