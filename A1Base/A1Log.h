/*
 *  A1Log.h
 *
 *  Created by Sergey Simonov on 02.06.10.
 *  Copyright 2010. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "A1String.h"
#import "A1Extern.h"
#import "A1Location.h"

#pragma mark -

A1_EXTERN void A1LogString (A1Location location, NSString *string);
  
#pragma mark -

#define A1_DLOG_STRING(string) \
        A1LogString (A1_LOCATION (), string)
  
#define A1_DLOG(...) \
        { \
          A1_V (__string, A1_STRING_WITH_FORMAT (__VA_ARGS__)); \
          A1_DLOG_STRING (__string); \
        } \

#define A1_DLOG_TAG_BEG \
        A1_DLOG (@">"); \

#define A1_DLOG_TAG_END \
        A1_DLOG (@"<");
