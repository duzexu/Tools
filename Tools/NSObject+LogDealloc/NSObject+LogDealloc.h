#import <Foundation/Foundation.h>
//  跟踪内存泄露
@interface NSObject (LogDealloc)

- (void)logOnDealloc;

@end
