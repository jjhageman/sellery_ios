//
//  A1Data.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/NSData.h>


#define A1_DATA_WITH_CONTENTS_OF_FILE (filename) \
        (NSData *)[NSData dataWithContentsOfFile: filename]

#define A1_DATA_WITH_BYTES(bytes, len) \
        (NSData *)[NSData dataWithBytes: bytes length: len]

#define A1_MUTABLE_DATA_WITH_LENGTH(...) \
        (NSMutableData *)[NSMutableData dataWithLength: __VA_ARGS__]
