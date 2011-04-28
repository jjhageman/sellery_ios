//
//  Requests.h
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelleryAppCommunicationKit.h"


@interface SelleryAppCommunicationKit (Requests)

- (void)requestImageUpload: (UIImage *)image
               contextInfo: (id)contextInfo;
- (void)requestItemUpload: (NSString *)email
                 provider: (NSString *)provider
                      uid: (NSString *)uid
                    token: (NSString *)token
                    title: (NSString *)title
              description: (NSString *)description
                    price: (NSString *)price
                  zipcode: (NSString *)zipcode
                 image_id: (NSString *)image_id
              contextInfo: (id)contextInfo;

- (void)cancelAllRequests;
- (void)onBeginRequest: (NSMutableURLRequest *)request
           contextInfo: (id)contextInfo;
- (void)onEndRequest: (NSMutableURLRequest *)request
         contextInfo: (id)contextInfo;

@end
