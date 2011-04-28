//
//  SelleryAppDelegate+Facebook.h
//  Sellery
//
//  Created by Sergey Simonov on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelleryAppDelegate.h"
#import "FBConnect.h"
#import "FBRequest.h"


@interface SelleryAppDelegate (Facebook) <FBSessionDelegate, FBRequestDelegate>

- (void)login;
- (void)logout;

@end
