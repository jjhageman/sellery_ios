//
//  SelleryAppCommunicationKit.h
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import "A1Macros.h"
#import "SelleryAppRESTfulDelegate.h"


#define IMAGE_API_ENDPOINT @"http://api.selleryapp.com/item_images.json"
#define ITEM_API_ENDPOINT @"http://api.selleryapp.com/items.json"

#define SelleryAppCommunicationKitF \
  ((RESTfulDelegate) ((nonatomic, retain)) ((id <SelleryAppRESTfulDelegate>))) \
  ((queue) ((nonatomic, retain)) ((NSOperationQueue *))) \

#define SelleryAppCommunicationKitNF \
  ((networkReachability) ((nonatomic, assign)) ((SCNetworkReachabilityRef))) \

@interface SelleryAppCommunicationKit : NSObject
{
  A1_PP_PROP_IVARS (SelleryAppCommunicationKitF);
  A1_PP_PROP_IVARS (SelleryAppCommunicationKitNF);
}

A1_PP_PROPS (SelleryAppCommunicationKitF);
A1_PP_PROPS (SelleryAppCommunicationKitNF);

- (BOOL)isNetworkReachable;
- (BOOL)isCellPhoneNetwork;

@end
