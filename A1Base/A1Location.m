//
//  A1Location.m
//
//  Created by Sergey Simonov on 02.06.10.
//  Copyright 2010. All rights reserved.
//

#import "A1Location.h"
#import "A1DeclareMacros.h"
#import "A1String.h"


A1Location A1LocationMake (char const *file, int line, char const *func)
{
  A1Location location = {
    .file = file,
    .line = line,
    .func = func
  };
  
  return location;
}

NSString *A1StringWithThreadIDDescription (void)
{
  A1_V (string, ([NSThread isMainThread] ? @"" : A1_STRING_WITH_FORMAT (@"[*%.*lx] ", sizeof (void *) * 2, (long int)[NSThread currentThread])));
  
  return string;
}

NSString* A1StringFromLocation (A1Location location)
{
  A1_V (file, location.file);
  A1_V (line, location.line);
  A1_V (func, location.func);
  
  A1_V (string, A1_STRING_WITH_FORMAT (@"%@%@ at %d (%s)",
                                       A1StringWithThreadIDDescription (),
                                       [[[NSFileManager defaultManager] stringWithFileSystemRepresentation: file length: strlen (file)] lastPathComponent],
                                       line,
                                       func));

  return string;
}
