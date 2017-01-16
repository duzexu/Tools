//
//  ProtocolDispatcher.h
//  Demo
//
//  Created by haijiao on 16/7/26.
//  Copyright © 2016年 olinone. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ADProtocolDispatch(__protocol__, ...)  \
    [ADProtocolDispatcher dispatcherProtocol:@protocol(__protocol__)  \
                            toImplemertors:[NSArray arrayWithObjects:__VA_ARGS__, nil]]

@interface ADProtocolDispatcher : NSObject

+ (id)dispatcherProtocol:(Protocol *)protocol toImplemertors:(NSArray *)implemertors;

@end
