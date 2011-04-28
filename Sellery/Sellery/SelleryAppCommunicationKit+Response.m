//
//  SelleryAppCommunicationKit+Response.m
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryAppCommunicationKit+Response.h"
#import "CJSONDeserializer.h"


@implementation SelleryAppCommunicationKit (Response)

- (void)requestDidFinishWithData: (NSData *)data
                     contextInfo: (id)contextInfo;
{
  if (data)
  {
    A1_ATV (bytes, data);
    A1_DLOG (@"Received response: %s", bytes);
  }
  
  A1_AV (RESTfulDelegate);
  A1_CHECK (nil != RESTfulDelegate);
  
  NSError *error = nil;
  A1_ATV (deserializer, CJSONDeserializer);
  
  // Convert from JSON to NSDictionary
  A1_V (jsonInfo, [deserializer deserializeAsDictionary: data
                                                  error: &error]);
  if (!jsonInfo)
  {
    [RESTfulDelegate error: error
               contextInfo: contextInfo];
  }
  else
  {
    [RESTfulDelegate responseWithDictionaryA: jsonInfo
                                 contextInfo: contextInfo];
  }
}

@end
