//
//  SelleryAppRESTfulOperation.h
//
//  Created by Sergey Simonov on 30.11.10.
//  Copyright 2010 Sergey Simonov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "A1Macros.h"


#define SelleryAppRESTfulOperationF \
  ((request) ((nonatomic, retain)) ((NSMutableURLRequest *))) \
  ((response) ((nonatomic, retain)) ((NSURLResponse *))) \
  ((connection) ((nonatomic, retain)) ((NSURLConnection *))) \
  ((data) ((nonatomic, retain)) ((NSMutableData *))) \
  ((contextInfo) ((nonatomic, retain)) ((id))) \

#define SelleryAppRESTfulOperationNF \
  ((isExecuting) ((assign)) ((BOOL))) \
  ((isFinished) ((assign)) ((BOOL))) \

@interface SelleryAppRESTfulOperation : NSOperation
{
  A1_PP_PROP_IVARS (SelleryAppRESTfulOperationF);
  A1_PP_PROP_IVARS (SelleryAppRESTfulOperationNF);
}

A1_PP_PROPS (SelleryAppRESTfulOperationF);
A1_PP_PROPS (SelleryAppRESTfulOperationNF);

- (id)initWithRequest: (NSMutableURLRequest *)request;

@end
