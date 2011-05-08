//
//  SelleryAppDelegate+RESTfull.m
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryAppDelegate+RESTfull.h"
#import "SelleryViewController.h"


@implementation SelleryAppDelegate (RESTfull)

- (void)onBeginRequest: (NSMutableURLRequest *)request
           contextInfo: (id)contextInfo;
{
  A1_DLOG_TAG_BEG;
  A1_DLOG_TAG_END;
}

- (void)onEndRequest: (NSMutableURLRequest *)request
         contextInfo: (id)contextInfo;
{
  A1_DLOG_TAG_BEG;
  A1_DLOG_TAG_END;
}

- (void)responseWithDictionaryA: (NSDictionary *)response
                    contextInfo: (id)contextInfo;
{
  A1_DLOG_TAG_BEG;
  
  [A1_APP_DELEGATE setUploading: NO];
  
  A1_V (selleryController, A1_KCAST (SelleryViewController, contextInfo));
  [selleryController uploadFinished: response];
  
  A1_DLOG_TAG_END;
}

- (void)error: (NSError *)error
  contextInfo: (id)contextInfo;
{
  A1_DLOG_TAG_BEG;

  [A1_APP_DELEGATE setUploading: NO];
  
  A1_V (selleryController, A1_KCAST (SelleryViewController, contextInfo));
  [selleryController networkError: error];
  
  A1_DLOG_TAG_END;
}

@end
