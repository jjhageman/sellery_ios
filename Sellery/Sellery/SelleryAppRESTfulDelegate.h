//
//  SelleryAppRESTfulDelegate.h
//  MFTVAppKit
//
//  Created by Sergey Simonov on 24.11.10.
//  Copyright 2010 Sergey Simonov. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelleryAppRESTfulDelegate

@required

- (void)onBeginRequest: (NSMutableURLRequest *)request
           contextInfo: (id)contextInfo;
- (void)onEndRequest: (NSMutableURLRequest *)request
         contextInfo: (id)contextInfo;

- (void)responseWithDictionaryA: (NSDictionary *)response
                    contextInfo: (id)contextInfo;

- (void)error: (NSError *)error
  contextInfo: (id)contextInfo;

@end
