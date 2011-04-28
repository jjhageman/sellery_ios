//
//  A1AutoreleasePoolMacros.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/NSAutoreleasePool.h>


#define A1_ARPOOL_BEG \
        NSAutoreleasePool *pool = [NSAutoreleasePool new];

#define A1_ARPOOL_END_R(...) \
        [__VA_ARGS__ retain]; \
        [pool release]; \
        [__VA_ARGS__ autorelease];

#define A1_ARPOOL_END \
        A1_ARPOOL_END_R (((id)nil))
