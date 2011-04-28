//
//  A1Check.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

# define A1_CHECK(...) \
         NSCAssert1 ((__VA_ARGS__), @"Condition not satisfying: %s", #__VA_ARGS__)

#define A1_UNEXPECTED() \
        abort ()
