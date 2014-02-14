//
//  NSObject+Association.m
//
//  Created by Maciej Swic on 03/12/13.
//  Released under the MIT license.
//

#import <objc/runtime.h>

#import "NSObject+Association.h"

@implementation NSObject (Association)

static char associatedObjectsKey;

- (id)associatedObjectForKey:(NSString*)key {
  NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);
  return [dict objectForKey:key];
}

- (void)setAssociatedObject:(id)object forKey:(NSString*)key {
  NSMutableDictionary *dict = objc_getAssociatedObject(self, &associatedObjectsKey);
  if (!dict) {
      dict = [[NSMutableDictionary alloc] init];
      objc_setAssociatedObject(self, &associatedObjectsKey, dict, OBJC_ASSOCIATION_RETAIN);
  } [dict setObject:object forKey:key];
}

@end
