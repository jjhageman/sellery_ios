//
//  A1Location.h
//
//  Created by Sergey Simonov on 02.06.10.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/NSString.h>
#import "A1Extern.h"


#pragma mark -

typedef struct
{
  char const *file;
  int line;
  char const *func;
} A1Location;

#pragma mark -

A1_EXTERN A1Location A1LocationMake (char const *file, int line, char const *func);
A1_EXTERN NSString* A1StringFromLocation (A1Location location);

#define A1_LOCATION() \
        A1LocationMake (__FILE__, __LINE__, __func__)

A1_EXTERN NSString* A1StringWithThreadIDDescription (void);
