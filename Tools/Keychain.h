//
//  Keychain.h
//  keyChain
//
//  keychain里保存的信息不会因App被删除而丢失
//
//  Created by DuZexu on 13-6-4.
//  Copyright (c) 2013年 Duzexu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface Keychain : NSObject
/**
 *  @brief  保存数据到keychain
 *
 *  @param  service  保存的关键字
 *  @param  data     要保存的数据
 */
+ (void)save:(NSString *)service data:(id)data;
/**
 *  @brief  从keychain加载数据
 *
 *  @param  service  关键字
 *
 *  @return 存储的数据
 */
+ (id)load:(NSString *)service;
/**
 *  @brief  从keychain删除数据
 *
 *  @param  service  关键字
 */
+ (void)delete:(NSString *)service;
@end
