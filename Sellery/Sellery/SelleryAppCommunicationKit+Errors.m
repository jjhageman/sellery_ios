//
//  SelleryAppCommunicationKit+Errors.m
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryAppCommunicationKit+Errors.h"


@implementation SelleryAppCommunicationKit (Errors)

- (NSError *)makeRESTfulErrorFromDescription: (NSString *)description
                                        code: (NSInteger)code;
{
  A1_CHECK (nil != description);
  
  A1_V (userInfo, A1_DICTIONARY_WITH_OBJECT_FOR_KEY (description, NSLocalizedDescriptionKey));
  
  A1_CUSTOM_NV (NSError, error, initWithDomain: NSPOSIXErrorDomain
                                          code: code
                                      userInfo: userInfo);
  
  return error;
}

- (void)requestDidFailWithError: (NSError *)error
                    contextInfo: (id)contextInfo;
{
  A1_DLOG_TAG_BEG;
  
  A1_AV (RESTfulDelegate);
  A1_CHECK (nil != RESTfulDelegate);
  
  [RESTfulDelegate error: error
             contextInfo: contextInfo];
  
  A1_DLOG_TAG_END;
}

@end
