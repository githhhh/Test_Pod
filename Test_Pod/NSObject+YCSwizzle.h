//
//  NSObject+YCSwizzle.h
//  iWeidao
//
//  Created by admin on 14/12/2.
//  Copyright (c) 2014年 yongche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YCSwizzle)
+ (void)swizzleInstanceSelector:(SEL)originalSelector
                withNewSelector:(SEL)newSelector;
@end
