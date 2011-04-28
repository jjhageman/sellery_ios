//
//  SelleryAppDelegate+RESTfull.h
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelleryAppDelegate.h"


@interface SelleryAppDelegate (RESTfull)

- (void)onBeginRequest: (NSMutableURLRequest *)request
           contextInfo: (id)contextInfo;
- (void)onEndRequest: (NSMutableURLRequest *)request
         contextInfo: (id)contextInfo;

- (void)responseWithDictionaryA: (NSDictionary *)response
                    contextInfo: (id)contextInfo;

- (void)error: (NSError *)error
  contextInfo: (id)contextInfo;

@end
