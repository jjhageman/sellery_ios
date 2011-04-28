//
//  SelleryAppCommunicationKit.m
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryAppCommunicationKit.h"

#import <netinet/in.h>


#define A1_SELF \
  SelleryAppCommunicationKit

@implementation A1_SELF

#pragma mark -

- (BOOL)isNetworkReachable;
{
  SCNetworkReachabilityFlags flags;
  SCNetworkReachabilityGetFlags (self.networkReachability, &flags);
  
  return (flags & kSCNetworkFlagsReachable);
}

- (BOOL)isCellPhoneNetwork;
{
  SCNetworkReachabilityFlags flags;
  SCNetworkReachabilityGetFlags (self.networkReachability, &flags);
  
  return (flags & kSCNetworkReachabilityFlagsIsWWAN);
}

#pragma mark -

- (id)init
{
  self = [super init];
  
  if (self)
  {
    // Part 1 - Create Internet socket addr of zero
    struct sockaddr_in zeroAddr;
    bzero (&zeroAddr, sizeof (zeroAddr));
    zeroAddr.sin_len = sizeof (zeroAddr);
    zeroAddr.sin_family = AF_INET;
    
    // Part 2- Create target in format need by SCNetwork
    A1_V (networkReachability, SCNetworkReachabilityCreateWithAddress (NULL, (struct sockaddr *) &zeroAddr));
    
    // Part 3 - Get the flags
    _networkReachability = networkReachability;
    
    // Create operation queue for requests
    A1_NV (NSOperationQueue, queue);
    [queue setMaxConcurrentOperationCount: 1]; // Required only one task per queue, do not change!
    self.queue = queue;
  }
  
  return self;
}

#pragma mark -

A1_PP_SELF_SYNTHESIZE_AND_DEALLOC;

@end
