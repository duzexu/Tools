//
//  NSObject+AutoDescription.h
//  Tools
//
//  Created by DuZexu on 14-2-14.
//  Copyright (c) 2014年 Duzexu. All rights reserved.
//

#import <Foundation/Foundation.h>
// Automatic description based on Reflection
@interface NSObject (AutoDescription)

// Reflects about self.
// Format: [ClassName {prop1 = val1; prop2 = val2; }].,
// SuperClass' properties included (until NSObject).
- (NSString *) autoDescription; // can be in real description or somewhere else

@end
