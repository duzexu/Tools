//
//  NSData+AsyncCacher.h
//  Meetweet
//
//  Created by Антон Буков on 28.06.13.
//  Copyright (c) 2013 Anton Bukov. All rights reserved.
//
//  NSData-AsyncCacher是NSData的一个category，用于从url和block中异步加载数据。请求数据使用NSCache缓存，可以多次请求

#import <Foundation/Foundation.h>

@interface NSData (AsyncCacher)

+ (void)getDataFromURL:(NSURL *)url
               toBlock:(void(^)(NSData * data, BOOL * retry))block;

+ (void)getDataFromURL:(NSURL *)url
               toBlock:(void(^)(NSData * data, BOOL * retry))block
             needCache:(BOOL)needCache;

@end
