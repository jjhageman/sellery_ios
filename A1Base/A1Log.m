//
//  A1Log.m
//
//  Created by Sergey Simonov on 02.06.10.
//  Copyright 2010. All rights reserved.
//

#import "A1DeclareMacros.h"
#import "A1Check.h"
#import "A1Log.h"
#import "A1String.h"
#import "A1AutoreleasePoolMacros.h"


NSString* stringWithLogMessage (A1Location location, NSString *string)
{
  A1_CHECK (nil != string);
  
  A1_V (message, A1_STRING_WITH_FORMAT (@"%@: %@",
                                        A1StringFromLocation (location),
                                        string));

  return message;
}

void A1LogString (A1Location location, NSString *string)
{
  A1_CHECK (nil != string);

  A1_ARPOOL_BEG;

#if 1
  // String to NSLog -> draft
  A1_V (message, stringWithLogMessage (location, string));
  NSLog (@"%@", message);
#endif

  A1_ARPOOL_END;
}
