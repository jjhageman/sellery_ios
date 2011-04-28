//
//  A1String.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import "A1DeclareMacros.h"
#import <Foundation/NSString.h>

#define A1_STRING_WITH_FORMAT(...) \
        (NSString *)[NSString stringWithFormat: __VA_ARGS__]

#define A1_STRING_WITH_UTF8_DATA(...) \
        A1_CUSTOM_NEW (NSString, initWithData: __VA_ARGS__ encoding: NSUTF8StringEncoding)

#define A1_STRING_WITH_UTF8_STRING(...) \
        ((NSString *)[NSString stringWithUTF8String: __VA_ARGS__])

#define A1_STRING_WITH_STRING(...) \
        ((NSString *)[NSString stringWithString: __VA_ARGS__])

#define A1_LOCALIZED_STRING(...) \
        A1_STRING_WITH_FORMAT (__VA_ARGS__)

#define A1_STRING_COMPARE_CASE_SENSITIVE(s1, s2) \
        ((BOOL)NSOrderedSame == [s1 compare: s2 options: NSLiteralSearch])

#pragma mark -

#define A1_STRING_FROM_CF(...) \
        (NSString *)(__VA_ARGS__)

#define A1_CF_FROM_STRING(...) \
        (CFStringRef)(__VA_ARGS__)
