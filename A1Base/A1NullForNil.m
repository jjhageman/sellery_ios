//
//  A1NullForNil.m
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import "A1NullForNil.h"
#import "A1DeclareMacros.h"


id A1NullForNil (id anObject)
{
  if (nil == anObject)
  {
    anObject = [NSNull null];
  }
  
  return anObject;
}

id A1NilForNull (id anObject)
{
  if ([anObject isKindOfClass: [NSNull class]])
  {
    anObject = nil;
  }
  
  return anObject;
}