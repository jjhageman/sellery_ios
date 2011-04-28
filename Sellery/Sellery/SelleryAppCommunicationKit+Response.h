//
//  SelleryAppCommunicationKit+Response.h
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelleryAppCommunicationKit.h"


@interface SelleryAppCommunicationKit (Response)

- (void)requestDidFinishWithData: (NSData *)data
                     contextInfo: (id)contextInfo;

@end
