//
//  NSObject+Association.h
//
//  Created by Maciej Swic on 03/12/13.
//  Released under the MIT license.
//
//  可以将任意的对象赋值给其它任意对象

#import <Foundation/Foundation.h>

@interface NSObject (Association)

- (id)associatedObjectForKey:(NSString*)key;
- (void)setAssociatedObject:(id)object forKey:(NSString*)key;

@end
