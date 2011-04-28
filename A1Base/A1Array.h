//
//  A1Array.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/NSArray.h>
#import <CoreFoundation/CFArray.h>


// nil casted to id just to avoid sentinel warnings
#define A1_ARRAY(...) \
        (NSArray *)[NSArray arrayWithObjects: __VA_ARGS__, (id)nil]

#define A1_MUTABLE_ARRAY_WITH_ARRAY(...) \
        (NSMutableArray *)[NSMutableArray arrayWithArray: __VA_ARGS__]

#pragma mark -

#define A1_ARRAY_FROM_CF(...) \
        (NSArray *)(__VA_ARGS__)

#define A1_CF_FROM_ARRAY(...) \
        (CFArrayRef)(__VA_ARGS__)
