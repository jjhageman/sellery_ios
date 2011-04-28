//
//  SelleryAppCommunicationKit+Errors.h
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelleryAppCommunicationKit.h"


@interface SelleryAppCommunicationKit (Errors)

- (NSError *)makeRESTfulErrorFromDescription: (NSString *)description
                                        code: (NSInteger)code;

- (void)requestDidFailWithError: (NSError *)error
                    contextInfo: (id)contextInfo;

@end
