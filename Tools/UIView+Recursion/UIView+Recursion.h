#import <UIKit/UIKit.h>

@interface UIView (Recursion)

//  以递归的方式遍历(查找)subview

/**
 Return YES from the block to recurse into the subview.
 Set stop to YES to return the subview.
 */
- (UIView*)findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse;

@end

